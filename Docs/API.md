# API Documentation

## Introduction

Welcome to the API documentation for FastAPI. This document provides detailed information on how to interact with our API, including endpoints, request parameters, response formats, and examples.


## Endpoints

### 1. /endpoint1

#### Description

This endpoint receives an image and then returns a binary number in a json response. 0 for an cataract eye image and 1 for a normal eye image.

#### Endpoint

`POST /endpoint_to_be_updated`

#### Parameters

| Name     | Type     | Description                       |
|----------|----------|-----------------------------------|
| `param1` | image    | Eye image to be Classified        |


#### Response Example

{
  "prediction": 1
}

#### Responses

| Code     | Description                       |
|----------|-----------------------------------|
| 200      |  Successful Response              |
| 422      |  Validation Error                 |







