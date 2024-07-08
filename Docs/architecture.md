# Machine Learning Model Architecture

## Overview

Our model for Cataract Detection is a Resnet50 + Attention module based CNN model. 

## Model Components

### Input Layer

The input layer consists of a 224*224 tensor which is effectively a resized image.

### Hidden Layers

1. The base layer is a pre - trained resnet50 model.
2. Spatial_attention module
3. Global_average_pooling and flatten layers

### Output Layer

The output layer is a sigmoid layer giving a number between 0 and 1 as a output.

## Key Components

### Loss Function

Binary - Cross entropy loss function used on sigmoid output layer.

### Optimization Algorithm

Adam optimizer with initial learing rate of 1e-3 was used.

### Metrics

Model achieved validation accuracy of over 90 percent.

## Example Code Snippet

Provide a simplified code snippet that outlines the model architecture in a programming language such as Python:
### Model neural network architecture

python
import tensorflow as tf

#### Model Input
input_tensor = Input(shape=input_shape)
base_model = ResNet50(include_top=False, weights='imagenet', input_tensor=input_tensor)

#### Add attention module
x = base_model.get_layer("conv4_block6_out").output
x = spatial_attention_module(x)

#### Spatial attention module
def spatial_attention_module(input_feature):
avg_pool = tf.reduce_mean(input_feature, axis=-1, keepdims=True)
max_pool = tf.reduce_max(input_feature, axis=-1, keepdims=True)
concat = tf.concat([avg_pool, max_pool], axis=-1)
attention = Conv2D(1, kernel_size=7, padding='same', activation='sigmoid')(concat)
return Multiply()([input_feature, attention])

#### rest of the ResNet50 layers
x = base_model.get_layer("conv5_block1_out")(x)
x = GlobalAveragePooling2D()(x)
x = Flatten()(x)
output = Dense(1, activation='sigmoid')(x)

model = Model(inputs=input_tensor, outputs=output)

#### Model Compilation
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate = 1e-3), loss='binary_crossentropy', metrics=['accuracy'])

#### Model Serialization and Loading
model.save("test_model.keras")
model.load("test_model.keras")

