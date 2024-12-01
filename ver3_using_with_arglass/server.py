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

import time
import psutil
from openai import OpenAI
from dotenv import load_dotenv
import os
import yaml

# Load YAML configuration
with open("config.yaml", "r") as file:
    config = yaml.safe_load(file)

# Extract values from the configuration file
SERVER_HOST = config['server']['host']
SERVER_PORT = config['server']['port']
RASPBERRY_PI_IP = config['raspberry_pi']['ip']
RASPBERRY_PI_PORT = config['raspberry_pi']['port']
YOLO_MODEL_PATH = config['paths']['yolo_model']
FONT_PATH = config['paths']['font']
MAX_EMPTY_HAND_FRAME = config['parameters']['max_empty_hand_frame']
MAX_NUM_DETECTED_LST = config['parameters']['max_num_detected_lst']
SLIDING_WINDOW_SIZE = config['parameters']['sliding_window_size']
CONFIDENCE_THRESHOLD = config['parameters']['confidence_threshold']
FPS_DISPLAY_COLOR = tuple(config['parameters']['fps_display_color'])

# Load the .env file
load_dotenv()

# Access the OpenAPI key
api_key = os.getenv('OPENAI_API')

# Khởi tạo client cho OpenAI với API key
client = OpenAI(api_key=api_key)

# Tạo hàm để sử dụng GPT-4o và theo dõi tài nguyên hệ thống
def process_text_with_resources(text: str):
    # Gửi yêu cầu đến API OpenAI GPT-4o
    response = client.chat.completions.create(
        model="gpt-4o",  # Sử dụng model GPT-4o
        messages=[
            {"role": "system", "content": "You are a spell-checking and grammar correction bot."},
            {
                "role": "user",
                "content": f"Correct the following text: '{text}'. Output only the corrected sentence."
            },
        ]
    )

    # Lấy kết quả đầu ra từ phản hồi của API
    corrected_sentence = response.choices[0].message.content  # Access 'content' directly

    # Trả về câu đã được chỉnh sửa
    return corrected_sentence

def process_vietnamese_text_with_resources(text: str):
    # Gửi yêu cầu đến API OpenAI GPT-4o
    response = client.chat.completions.create(
        model="gpt-4o",  # Sử dụng model GPT-4o
        messages=[
            {"role": "system", "content": "You are a spell-checking and grammar correction bot."},
            {
                "role": "user",
                "content": f"Correct the following text then convert to Vietnamese: '{text}'. Output only the Vietnamese sentence."
            },
        ]
    )
    # Lấy kết quả đầu ra từ phản hồi của API
    corrected_sentence = response.choices[0].message.content  # Access 'content' directly
    # Trả về câu đã được chỉnh sửa
    return corrected_sentence


# Load the pre-trained YOLOv8n model
model = YOLO(YOLO_MODEL_PATH )

# Initialize MediaPipe Hands
mp_hands = mp.solutions.hands
hands = mp_hands.Hands()

# Thiết lập socket server để chờ kết nối từ app
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # Thêm dòng này để có thể tái sử dụng địa chỉ
server_socket.bind((SERVER_HOST , SERVER_PORT))
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
    return ''.join(map(str, arr))

def put_vietnamese_text(img, text, position, font_path, font_size, color):
    # Chuyển đổi hình ảnh từ OpenCV sang PIL
    pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    draw = ImageDraw.Draw(pil_img)
    font = ImageFont.truetype(font_path, font_size)
    draw.text(position, text, font=font, fill=color)

    # Chuyển đổi hình ảnh từ PIL sang OpenCV
    img = cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)
    return img

label_map = {0: "a",
             1: "b",
             2: "c",
             3: "d",
             4: "e",
             5: "f",
             6: "g",
             7: "h",
             8: "i",
             9: "j",
             10: "k",
             11: "l",
             12: "m",
             13: "n",
             14: "o",
             15: "p",
             16: "q",
             17: "r",
             18: "s",
             19: "t",
             20: "u",
             21: "v",
             22: "w",
             23: "x",
             24: "y",
             25: "z",
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
max_empty_hand_frame = MAX_EMPTY_HAND_FRAME 
empty_hand_frame = 0
font_path = "Disney.ttf"
result = 0
show_result = ""

# Define a deque to store the last N results for smoothing
N = 12  # Size of the sliding window
result_buffer = collections.deque(maxlen=N)

frame_count = 0  # Counter to keep track of frames

detected_lst = []
max_num_detected_lst = MAX_NUM_DETECTED_LST 
selected_language = "VI"  # Mặc định là tiếng Việt

# Hàm lắng nghe cập nhật ngôn ngữ từ client
def listen_for_language_update(client_socket):
    global selected_language
    client_socket.settimeout(1.0)  # Giới hạn thời gian chờ đợi
    while True:
        try:
            data = client_socket.recv(2)
            if data:
                selected_language = data.decode('utf-8')
                print(f"Ngôn ngữ được cập nhật thành: {selected_language}")
            else:
                break  # Thoát nếu không nhận được dữ liệu nào
        except socket.timeout:
            continue  # Tiếp tục lặp lại nếu hết thời gian chờ
        except Exception as e:
            print(f"Lỗi khi cập nhật ngôn ngữ: {e}")
            break

# Hàm xử lý và gửi khung hình
def process_and_send_frames(client_socket):
    global selected_language, frame_count, result, empty_hand_frame, sign_arr, prev_time, result_buffer, detected_lst, max_num_detected_lst, max_empty_hand_frame, show_result, corrected_text
    data = b""
    payload_size = struct.calcsize("<L")

    corrected_text = ""

    # # Nhận ngôn ngữ từ client và khởi tạo ngôn ngữ mặc định
    # data = client_socket.recv(2)
    # selected_language = data.decode('utf-8')
    # print(f"Ngôn ngữ ban đầu được chọn là: {selected_language}")

    # Tạo luồng phụ để lắng nghe cập nhật ngôn ngữ
    language_thread = threading.Thread(target=listen_for_language_update, args=(client_socket,))
    language_thread.daemon = True
    language_thread.start()

    # Kết nối tới Raspberry Pi để nhận hình ảnh
    raspberry_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    raspberry_socket.connect((RASPBERRY_PI_IP , RASPBERRY_PI_PORT))

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

            # Quay và lật hình ảnh nếu cần
            frame = cv2.flip(frame, 0)
            frame = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)

            # Convert the frame color from BGR to RGB
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            detections = model(frame)[0]
            frame, result, status = draw_detections(frame, detections)

            detected_lst.append(result)

            if not status:
                    empty_hand_frame += 1

            if len(detected_lst) >= max_num_detected_lst:
                most_common_result = np.bincount(detected_lst).argmax()
                detected_lst = []
            
                if most_common_result != 99:
                    sign_arr = np.append(sign_arr, label_map[most_common_result])
                    if len(sign_arr) > 0:
                        show_result = numpy_array_to_string(sign_arr)
                    empty_hand_frame = 0

            if empty_hand_frame == max_empty_hand_frame:
                if len(sign_arr) > 5:
                    text_input = numpy_array_to_string(sign_arr)
                    if selected_language == "EN":
                        corrected_text = process_text_with_resources(text_input)
                    else:
                        corrected_text = process_vietnamese_text_with_resources(text_input)
                    sign_arr = [corrected_text]
                    show_result = corrected_text
                    # print(f"converted result: {show_result}")

            if empty_hand_frame == (max_empty_hand_frame + 1):
                sign_arr = np.empty(0)
                show_result = ""
            
            curr_time = datetime.datetime.now()
            delta_time = curr_time - prev_time
            fps = 1 / delta_time.total_seconds()
            prev_time = curr_time

            # Display FPS on the frame
            FPS_COLOR = (153, 255, 204)
            fps_text = f"FPS: {fps:.2f}"
            cv2.putText(frame, fps_text, (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, FPS_COLOR, 2)

            # Function to split text into lines of max 20 characters
            def split_text(text, length=45):
                return [text[i:i + length] for i in range(0, len(text), length)]

            # Create a separate window for displaying the results
            result_window = np.zeros((200, 1500, 3), dtype=np.uint8)

            # Convert numpy array to string and split it into lines of 20 characters
            lines = split_text(show_result)

            # Display each line in the window, adjusting vertical position for each
            y_pos = 50
            for line in lines:
                cv2.putText(result_window, line, (10, y_pos), cv2.FONT_HERSHEY_COMPLEX, 1.5, (255, 255, 255), 2)
                y_pos += 50  # Adjust vertical position for each line

            cv2.imshow('Hand Detection', frame)
            cv2.imshow("Result window", result_window)

            # Prepare the data to be sent
            print(f"detected_result: {show_result}")

            # Chuẩn bị dữ liệu để gửi
            message = f"{fps:.2f},{corrected_text}"
            message_bytes = message.encode('utf-8')
            message_length = struct.pack('<L', len(message_bytes))
            client_socket.sendall(message_length + message_bytes)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    finally:
        client_socket.close()
        raspberry_socket.close()
        cv2.destroyAllWindows()

# Khởi tạo server và chờ kết nối từ client
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind((SERVER_HOST, SERVER_PORT))
server_socket.listen(1)

while True:
    client_socket, addr = server_socket.accept()
    print(f"Connected to {addr}")
    thread = threading.Thread(target=process_and_send_frames, args=(client_socket,))
    thread.start()
