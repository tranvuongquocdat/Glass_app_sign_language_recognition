# Server: FastAPI
from fastapi import FastAPI, Request
from pydantic import BaseModel
import base64
import tempfile
import cv2
from ultralytics import YOLO
from typing import List
from tqdm import tqdm

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Thay "*" bằng danh sách origin được phép nếu cần
    allow_methods=["*"],  # Cho phép tất cả các phương thức
    allow_headers=["*"],  # Cho phép tất cả các headers
)



class VideoRequest(BaseModel):
    videos: List[str]  # List of base64-encoded video strings
    isVietnamese: bool

@app.post("/process_video/")
async def process_video(request: VideoRequest):
    results = []

    model = YOLO("yolov8n.pt")  # Load YOLOv8 model

    for video_base64 in request.videos:
        # Decode the base64 string to video file
        video_data = base64.b64decode(video_base64)
        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as temp_video:
            temp_video.write(video_data)
            temp_path = temp_video.name

        # Process video with YOLOv8
        detections = []
        cap = cv2.VideoCapture(temp_path)
        total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

        with tqdm(total=total_frames, desc="Processing Video", unit="frame") as pbar:
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                results_frame = model(frame, verbose=False)
                frame_classes = []
                for result in results_frame[0].boxes:
                    if float(result.conf) >= 0.6:  # Apply confidence threshold
                        frame_classes.append(model.names[int(result.cls)])
                
                detections.append(frame_classes)  # Append classes for this frame
                pbar.update(1)

        cap.release()

        # Collect detections for this video
        results.append(detections)

    # Prepare response
    language = "vi" if request.isVietnamese else "en"
    response = {
        "language": language,
        "results": "successfully constructed"
    }
    return response
