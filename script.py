from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import whisper
import os

model = whisper.load_model("turbo",download_root='.',device='cuda')
app = FastAPI()
@app.post("/transcribe/")
async def transcribe_audio(file: UploadFile = File(...), language: str = "fa"):
    os.makedirs("/app/temp", exist_ok=True)
    file_location = f"/app/temp/{file.filename}"
    with open(file_location, "wb") as f:
        f.write(await file.read())
    result = model.transcribe(file_location, language=language,)
    transcription = result["text"]
    os.remove(file_location)
    return JSONResponse(content={"transcription": transcription})
