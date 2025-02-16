from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import base64
import cv2
import numpy as np
from ultralytics import YOLO
import time
import socket

app = FastAPI()
model = YOLO('main_model_v2.pt')

# Add FPS tracking variables
frame_times = []
last_fps_update = time.time()
current_fps = 0

# Add global variable to track window state
detection_window_active = False

class ImageRequest(BaseModel):
    image: str  # base64 string

@app.post("/detect")
async def detect_objects(request: ImageRequest):
    try:
        global frame_times, last_fps_update, current_fps, detection_window_active
        detection_window_active = True
        
        # Record frame time
        current_time = time.time()
        frame_times.append(current_time)
        
        # Remove frames older than 3 seconds
        current_frame_times = [t for t in frame_times if current_time - t <= 3.0]
        frame_times = current_frame_times
        
        # Update FPS every 3 seconds
        if current_time - last_fps_update >= 3.0:
            if len(frame_times) > 1:
                current_fps = len(frame_times) / 3.0
            last_fps_update = current_time
        
        # Decode base64 image
        img_bytes = base64.b64decode(request.image)
        nparr = np.frombuffer(img_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        # Run detection
        results = model(img)
        
        # Process results
        detected_objects = []
        for r in results[0].boxes.data:
            x1, y1, x2, y2, conf, cls = r
            label = results[0].names[int(cls)]
            detected_objects.append(f"{label}")
        
        return {"objects": detected_objects, "fps": round(current_fps, 2)}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/stop_detection")
async def stop_detection():
    global detection_window_active
    if detection_window_active:
        detection_window_active = False
        cv2.destroyAllWindows()
    return {"status": "detection stopped"}

@app.get("/test")
async def test_connection():
    return {"status": "connected"}

if __name__ == "__main__":
    # Get the local IP address
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    print(f"\nServer running at: http://{local_ip}:8000")
    
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 