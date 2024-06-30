# -*- coding: utf-8 -*-
"""
Created on Tue Nov 17 21:40:41 2020

@author: win10
"""

import uvicorn
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import numpy as np
from tensorflow.keras.models import load_model
import pandas as pd
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




app = FastAPI()
classifier = load_model("test_model.h5")


# @app.get('/')
# def index():
#     return {'message': 'Hello, World'}

# @app.get('/{name}')
# def get_name(name: str):
#     return {'Testing..': f'{name}'}


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


if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)
    
#uvicorn app:app --reload
