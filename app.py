# -*- coding: utf-8 -*-
"""
Created on Tue Nov 17 21:40:41 2020

@author: win10
"""

# 1. Library imports
import uvicorn
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import numpy as np
import tensorflow as tf
import pandas as pd
import tempfile
import os
import requests
# Global variable to store the loaded model
loaded_model = None

# Function to download and load TensorFlow model
def load_model_from_github():
    global loaded_model
    if loaded_model is None:
        model_url = "https://github.com/Tanishq-Godha/FastAPI_test/tree/main/model_file"  # Replace with your GitHub repository URL
        local_dir = tempfile.mkdtemp()
        model_path = os.path.join(local_dir, 'tensorflow_model')

        # Download the model directory recursively
        download_files(model_url, model_path)

        # Load the TensorFlow model
        loaded_model = tf.keras.models.load_model(model_path)
    
    return loaded_model

# Function to download files recursively from GitHub
def download_files(url, save_dir):
    response = requests.get(url, stream=True)
    response.raise_for_status()
    with open(save_dir, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)



# 2. Create the app object
app = FastAPI()
classifier = load_model_from_github()

# 3. Index route, opens automatically on http://127.0.0.1:8000
@app.get('/')
def index():
    return {'message': 'Hello, World'}

# 4. Route with a single parameter, returns the parameter within a message
#    Located at: http://127.0.0.1:8000/AnyNameHere
@app.get('/{name}')
def get_name(name: str):
    return {'Testing..': f'{name}'}

# 3. Expose the prediction functionality, make a prediction from the passed
#    JSON data and return the predicted Bank Note with the confidence
@app.post('/predict')
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        img = np.array(contents)
        prediction = classifier.predict([img])

        return JSONResponse({
            'prediction': prediction
        })
    except Exception as e:
        return JSONResponse({
            'error': f'Error during prediction: {str(e)}'
        }, status_code=500)

# 5. Run the API with uvicorn
#    Will run on http://127.0.0.1:8000
if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)
    
#uvicorn app:app --reload