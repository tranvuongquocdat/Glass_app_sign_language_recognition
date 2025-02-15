@echo off
uvicorn server3:app --host 0.0.0.0 --reload --log-level=debug
pause
