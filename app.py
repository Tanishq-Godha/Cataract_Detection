# -*- coding: utf-8 -*-
"""
Created on Tue Nov 17 21:40:41 2020

@author: win10
"""

import uvicorn
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import numpy as np
import tensorflow as tf
# import imageio
from PIL import Image
import os



# import requests

# loaded_model = None


# def load_model_from_github():
#     global loaded_model
#     if loaded_model is None:
#         model_url = "https://github.com/Tanishq-Godha/FastAPI_test/tree/master/test_model"  # Replace with your GitHub repository URL
#         local_dir = tempfile.mkdtemp()
#         model_path = os.path.join(local_dir, 'tensorflow_model')

 
#         download_files(model_url, model_path)


#         loaded_model = tf.keras.models.load_model(model_path)
    
#     return loaded_model


# def download_files(url, save_dir):
#     response = requests.get(url, stream=True)
#     response.raise_for_status()
#     with open(save_dir, 'wb') as f:
#         for chunk in response.iter_content(chunk_size=8192):
#             f.write(chunk)



model_path = os.path.join(os.path.dirname(__file__), 'test_model.keras')
app = FastAPI()
classifier = tf.keras.models.load_model(model_path)


def preprocess_image(contents, target_size=(224, 224)):
    # Load image using PIL
    img = Image.open(contents.file)
    # Resize image
    img_resized = img.resize(target_size)

    # Convert PIL image to numpy array
    img_array = np.asarray(img_resized)
    # Expand dimensions to match model expected input shape
    img_input = np.expand_dims(img_array, axis=0)
    # Preprocess image for model prediction
    return img_input
   

@app.post('/predict')
async def predict(file: UploadFile = File(...)):
    try:
        img_input = preprocess_image(file)
        prediction = classifier.predict(img_input)[0][0]
        if prediction > 0.5:
            prediction = int(1)
        else:
            prediction = int(0)

        return JSONResponse({
            'prediction': prediction
        })
    except Exception as e:
        return JSONResponse({
            'error': f'Error during prediction: {str(e)}'
        }, status_code=500)


if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)
    
#uvicorn app:app --reload
