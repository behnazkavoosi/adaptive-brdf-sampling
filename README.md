# Adaptive Sampling for BRDF Acquisition 

This repository contains the reference implementation for our paper **“Adaptive Sampling for BRDF Acquisition.”**  
It provides a full pipeline for **BRDF clustering**, **sampling**, **classification**, and **reconstruction**.

---

## ⚙️ Requirements

**MATLAB**
- Tested on MATLAB **R2020b+**
- Suggested toolboxes:
  - Statistics & Machine Learning
  - Optimization
  - Image Processing (recommended)

**Python (for the classifier notebook)**
- Python **3.9+**
- Recommended:
  ```bash
  pip install numpy scikit-learn matplotlib jupyter
  ```

## 🗃️ Datasets
This project uses two types of data:

**1) Image Dataset for Classifier:** [Image dataset](https://liuonline-my.sharepoint.com/:u:/g/personal/behka57_liu_se/EXr5CAJ6h4ZDlz9JiQzAJfoBDDH_9nRX9iPfRkMUMhphXg?e=8vgfgz)
> **Note:** The dataset includes 200×200 images of materials rendered under a point light moving from 45° to 90°,  
> but the classifier only uses angles from 75° to 90° as input.

**2) BRDF Datasets for MATLAB Pipeline:** [MERL](https://cdfg.csail.mit.edu/wojciech/brdfdatabase), [Extended MERL](https://ana-serrano.github.io/projects/Material-Appearance.html), [RGL-EPFL](https://rgl.epfl.ch/materials)
> **Note:** RGL-EPFL BRDFs can be reparametrized into MERL space using the code from [chenzhekl/rgl-to-merl](https://github.com/chenzhekl/rgl-to-merl).

## ▶️ How to Run

Run the following scripts **in this exact order** to reproduce the results:

### 1️⃣ runClustering.m
```matlab
runClustering
```
- Loads BRDF data (MERL, EPFL, Extended MERL).
- Computes feature representations and prepares error matrix for clustering.

### 2️⃣ findClusters.m
```matlab
findClusters
```
- Performs clustering using hierarchical clustering.
- Saves clusters and plots the data points.

### 3️⃣ runSampling.m
```matlab
runSampling
```
- Finds optimal sample locations given the sample count obtained from step 2️⃣.

> **Note:** This script uses FROST-BRDF sampling as an example, but other techniques (e.g., Nielsen et al.) can also be used.

### 4️⃣ classification_200x200.ipynb
Open and run the Jupyter notebook:
```
classification_200x200.ipynb
```
- Trains and evaluates a classifier on image data (200×200 patches or configured size).
- Uses the adaptive sampling results for training and validation.

> **Note:** Before running the notebook, execute `saveLabels` and `saveTrainNames` in MATLAB to prepare the data for classification.

### 5️⃣ runClassRecon.m
```matlab
runClassRecon
```
- Reconstructs BRDFs in the testing set based on the classification results.
- Saves reconstructed BRDF files and evaluation metrics.

## 📄 Citation
If you use this code, please cite:

> **Adaptive Sampling for BRDF Acquisition**  
> *Behnaz Kavoosighafi, Saghi Hajisharif, Jonas Unger, and Ehsan Miandji*  
> Under Review (2025)

```bibtex
@article{Kavoosighafi2025AdaptiveBRDF,
  title     = {Adaptive Sampling for BRDF Acquisition},
  author    = {Behnaz Kavoosighafi and Saghi Hajisharif and Jonas Unger and Ehsan Miandji},
  booktitle = {Under Review},
  year      = {2025}
}
```
## 📬 Contact

For inquiries, please contact: **behnaz.kavoosighafi@liu.se**

## 🛡️ License

This work is licensed under a [**Creative Commons Attribution–NonCommercial–ShareAlike 4.0 International License (CC BY-NC-SA 4.0)**](https://creativecommons.org/licenses/by-nc-sa/4.0/).

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
