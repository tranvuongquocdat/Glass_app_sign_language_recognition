import socket
import struct
import cv2
import mediapipe as mp
import numpy as np
import datetime
from ultralytics import YOLO
import collections
from PIL import ImageFont, ImageDraw, Image
import threading
import signal
import sys

# Load the pre-trained YOLOv8n model
model = YOLO(r"models/main_model.pt")

# Initialize MediaPipe Hands
mp_hands = mp.solutions.hands
hands = mp_hands.Hands()

# Thiết lập socket client để kết nối với Raspberry Pi
raspberry_pi_ip = '172.20.10.12'  # Địa chỉ IP của Raspberry Pi
raspberry_pi_port = 8000

# Thiết lập socket server để chờ kết nối từ app
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # Thêm dòng này để có thể tái sử dụng địa chỉ
server_socket.bind(('0.0.0.0', 8001))
server_socket.listen(1)

print("Waiting for connection from app...")

# Initialize MediaPipe drawing utils for drawing hands on the image
mp_drawing = mp.solutions.drawing_utils

def draw_detections(frame, last_detections):
    CONFIDENCE_THRESHOLD = 0.6
    COLOR = (153, 255, 204)
    result = 99
    status = False
    if last_detections is not None:
        for data in last_detections.boxes.data.tolist():
            confidence = data[4]
            if float(confidence) < CONFIDENCE_THRESHOLD:
                continue
            status = True
            xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), COLOR, 2)
            class_id = data[5]
            result = class_id
            text = f"{class_id}, {confidence:.2f}"
            cv2.putText(frame, text, (xmin, ymin - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, COLOR, 2)
    return frame, result, status

def numpy_array_to_string(arr):
    return ' '.join(map(str, arr))

def put_vietnamese_text(img, text, position, font_path, font_size, color):
    # Chuyển đổi hình ảnh từ OpenCV sang PIL
    pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    draw = ImageDraw.Draw(pil_img)
    font = ImageFont.truetype(font_path, font_size)
    draw.text(position, text, font=font, fill=color)

    # Chuyển đổi hình ảnh từ PIL sang OpenCV
    img = cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)
    return img

label_map = {0: "Toi",
             1: "",
             2: "com",
             3: "",
             4: "",
             5: "",
             6: "",
             7: "",
             8: "",
             9: "",
             10: "ban",
             11: "",
             12: "",
             13: "",
             14: "an",
             15: "",
             16: "",
             17: "",
             18: "",
             19: "",
             20: "di",
             21: "choi",
             22: "chao",
             23: "",
             24: "",
             25: "",
             26: "",
             27: "",
             28: "",
             29: "",
             30: "",
             }

prev_time = datetime.datetime.now()

sign_arr = np.empty(0)
pred_count = 0
result_arr = []
max_empty_hand_frame = 30
empty_hand_frame = 0
current_result = 88
font_path = "Disney.ttf"
result = 0

# Define a deque to store the last N results for smoothing
N = 12  # Size of the sliding window
result_buffer = collections.deque(maxlen=N)

frame_count = 0  # Counter to keep track of frames

def process_and_send_frames(client_socket):
    global frame_count, result, empty_hand_frame, sign_arr, current_result, prev_time, result_buffer
    data = b""
    payload_size = struct.calcsize("<L")
    
    # Kết nối tới Raspberry Pi để nhận hình ảnh
    raspberry_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    raspberry_socket.connect((raspberry_pi_ip, raspberry_pi_port))

    try:
        while True:
            while len(data) < payload_size:
                packet = raspberry_socket.recv(4096)
                if not packet:
                    return
                data += packet

            packed_msg_size = data[:payload_size]
            data = data[payload_size:]
            msg_size = struct.unpack("<L", packed_msg_size)[0]

            while len(data) < msg_size:
                packet = raspberry_socket.recv(4096)
                if not packet:
                    return
                data += packet

            frame_data = data[:msg_size]
            data = data[msg_size:]

            # Giải mã hình ảnh
            frame = cv2.imdecode(np.frombuffer(frame_data, dtype=np.uint8), cv2.IMREAD_COLOR)

            # Rotate frame
            frame = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)

            # Convert the frame color from BGR to RGB
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            detections = model(frame)[0]
            frame, result, status = draw_detections(frame, detections)

            if result != 99:
                result_buffer.append(result)
                empty_hand_frame = 0
            
            if not status:
                empty_hand_frame += 1

            if len(result_buffer) > 0:
                # Use the most common element in the buffer as the stable result
                result = max(set(result_buffer), key=result_buffer.count)
                if result != current_result:
                    sign_arr = np.append(sign_arr, label_map[result])
                    current_result = result

            if empty_hand_frame == max_empty_hand_frame:
                if result == 0:
                    current_result = 88
                else:
                    current_result = result
                sign_arr = np.empty(0)
            
            curr_time = datetime.datetime.now()
            delta_time = curr_time - prev_time
            fps = 1 / delta_time.total_seconds()
            prev_time = curr_time

            # Display FPS on the frame
            FPS_COLOR = (153, 255, 204)
            fps_text = f"FPS: {fps:.2f}"
            cv2.putText(frame, fps_text, (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, FPS_COLOR, 2)

            # Create a separate window for displaying the results
            result_window = np.zeros((80, 1000, 3), dtype=np.uint8)
            show_result = numpy_array_to_string(sign_arr)
            cv2.putText(result_window, str(show_result), (10, 50), cv2.FONT_HERSHEY_COMPLEX, 1.5, (255, 255, 255), 2)

            cv2.imshow('Hand Detection', frame)
            cv2.imshow("Result window", result_window)

            frame_count += 1
            if frame_count % 10 == 0:
                # Prepare the data to be sent
                message = f"{fps:.2f},{show_result}"
                message_bytes = message.encode('utf-8')
                message_length = struct.pack('<L', len(message_bytes))
                client_socket.sendall(message_length + message_bytes)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    finally:
        client_socket.close()
        raspberry_socket.close()
        cv2.destroyAllWindows()

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    server_socket.close()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

while True:
    client_socket, addr = server_socket.accept()
    print(f"Connected to {addr}")
    thread = threading.Thread(target=process_and_send_frames, args=(client_socket,))
    thread.start()
