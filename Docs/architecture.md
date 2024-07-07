# Model Architecture
- Model Used: **ResNet50 + Attention**
- Input Shape: **(224, 224, 3)**
- Output: **Float between 0(Cataract) and 1(Normal)**
- Basic I/O flow: 
    ![alt text](https://github.com/Tanishq-Godha/Cataract_Detection/blob/master/Docs/images/Copy%20of%20SIDDHI_flowchart(1).png?raw=true)
    ## Pre-Processing:
    - **Lens Cropping:** Cropping the image of eye to its Iris portion for better accuracy on prediction.
    - **Resizing Image:** Resizing the image to meet the model input critera.  
	## Block 1- ResNet50:
	- Contains Deep CNN Layers with Residual Connections 
	## Block2- Attention Module:
	- contains Attention kernel(sigmoid activation) which helps to emphasize more on important features as trained on.
	## Dataset:
	- The Dataset Consists of a total of 9000 images:
		+ 4131 with Cataract Eyes
		+ 4869 with Normal Eyes
	- Image Resolution: 2048 px * 1536 px
	- Image Type: PNG
	## Training:
	![alt text](https://github.com/Tanishq-Godha/Cataract_Detection/blob/master/Docs/images/SIDDHI_flowchart(2).png?raw=true) 