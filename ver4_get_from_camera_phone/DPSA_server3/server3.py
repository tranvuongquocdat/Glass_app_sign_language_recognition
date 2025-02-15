from fastapi import FastAPI
from pydantic import BaseModel
import base64
import os
import cv2
from ultralytics import YOLO
from typing import List
from tqdm import tqdm
import socket
import logging

from fastapi.middleware.cors import CORSMiddleware

# Tắt log không cần thiết của uvicorn
logging.getLogger("uvicorn.access").disabled = True
logging.getLogger("uvicorn.error").disabled = True

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

# Hàm lấy IP của thiết bị
def get_device_ip():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    return ip_address

# In ra IP khi khởi động
@app.on_event("startup")
async def startup_event():
    ip_address = get_device_ip()
    print(f"Server is running on IP: {ip_address}")

# Đảm bảo thư mục tmp_videos tồn tại
TMP_VIDEO_DIR = "tmp_videos"
os.makedirs(TMP_VIDEO_DIR, exist_ok=True)

@app.post("/process_video/")
async def process_video(request: VideoRequest):
    results = ""  # Sử dụng chuỗi để lưu kết quả

    model = YOLO("main_model_v2.pt")  # Load YOLOv8 model

    for idx, video_base64 in enumerate(request.videos):
        # Decode the base64 string to video file
        video_data = base64.b64decode(video_base64)
        temp_path = os.path.join(TMP_VIDEO_DIR, f"video_{idx}.mp4")

        # Lưu tệp video vào thư mục tmp_videos
        with open(temp_path, "wb") as temp_video:
            temp_video.write(video_data)

        # Process video with YOLOv8
        cap = cv2.VideoCapture(temp_path)

        video_results = []  # Tạm lưu các phát hiện cho video này

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            # frame = cv2.resize(frame, (640, 640))

            results_frame = model(frame, verbose=False)

            frame_classes = []

            for result in results_frame[0].boxes:
                if float(result.conf) >= 0.6:  # Apply confidence threshold
                    frame_classes.append(model.names[int(result.cls)])

            if frame_classes:  # Chỉ thêm vào nếu có phát hiện
                video_results.extend(frame_classes)

        cap.release()
        cv2.destroyAllWindows()

        if video_results:  # Chỉ thêm kết quả nếu không rỗng
            results += ", ".join(video_results)

    # Loại bỏ dấu phẩy không cần thiết (nếu có)
    results = results.replace(", ", "")
    # Chuẩn bị response
    response = {"results": results}
    print("response: ", response)
    return response
