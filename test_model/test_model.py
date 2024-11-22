import os
from openai import OpenAI
import gradio as gr
import webbrowser  # Thư viện để mở trình duyệt
import threading  # Để chạy ứng dụng Gradio song song
import signal  # Để xử lý tín hiệu kết thúc chương trình
from dotenv import load_dotenv
import os

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
        {"role": "system", "content": "Bạn là một bot kiểm tra chính tả và ngữ pháp tiếng Việt."},
        {
            "role": "user",
            "content": f"Kiểm tra chính tả, dấu câu và ngữ pháp của đoạn văn sau: '{text}'. Chỉ xuất ra câu đã được chỉnh sửa."
        },
    ]
)
    # Lấy kết quả đầu ra từ phản hồi của API
    corrected_sentence = response.choices[0].message.content  # Access 'content' directly
    # Trả về câu đã được chỉnh sửa
    return corrected_sentence

# Hàm chính để gọi xử lý theo ngôn ngữ
def process_text(text, language):
    if language == "English":
        return process_text_with_resources(text)
    elif language == "Tiếng Việt":
        return process_vietnamese_text_with_resources(text)
    else:
        return "Please select a valid language."

# Giao diện Gradio
interface = gr.Interface(
    fn=process_text,
    inputs=[
        gr.Textbox(label="Enter text to process"),
        gr.Radio(choices=["English", "Tiếng Việt"], label="Language"),
    ],
    outputs=gr.Textbox(label="Corrected Text"),
    title="Spell and Grammar Checker",
    description="Correct your text in English or Vietnamese."
)

# Hàm để tự mở trình duyệt
def open_browser():
    webbrowser.open("http://127.0.0.1:7860")

# Chạy ứng dụng Gradio và tự động mở trình duyệt
def launch_app():
    # Tạo thread để đảm bảo chương trình chạy không bị khóa
    threading.Timer(1, open_browser).start()
    interface.launch(server_name="127.0.0.1", server_port=7860)

# Hàm xử lý khi nhận tín hiệu đóng
def signal_handler(sig, frame):
    print("Shutting down server...")
    os._exit(0)  # Kết thúc tất cả luồng

# Đăng ký bắt tín hiệu SIGINT (Ctrl + C) hoặc SIGTERM (đóng chương trình)
signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

# Gọi hàm khởi chạy ứng dụng
launch_app()