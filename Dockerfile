# Use PyTorch as the base image
FROM docker.arvancloud.ir/python:3.9-slim

# Set working directory
WORKDIR /app
RUN mkdir -p /app/temp
RUN chmod -R 777 /app/temp
COPY script.py .
COPY requirements.txt .

COPY check_and_copy.sh /scripts/
RUN chmod +x /scripts/check_and_copy.sh
RUN /scripts/check_and_copy.sh

RUN pip install --no-cache-dir pytorch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0  pytorch-cuda=11.8 -c pytorch -c nvidia

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Install system dependencies
RUN apt-get update && apt-get install -y ffmpeg && \
    apt-get clean

# Expose API port
EXPOSE 8010

# Run FastAPI server
CMD ["uvicorn","script:app" ,"--host" ,"0.0.0.0" ,"--port","8010" ,"--reload"]
