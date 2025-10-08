# Adaptive Sampling for BRDF Acquisition 

This repository contains the reference implementation for our paper  
**“Adaptive Sampling for BRDF Acquisition.”**  
It provides a full pipeline for **BRDF clustering**, **adaptive sampling**, **classification**, and **reconstruction**.

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

**1) Image Dataset for Classifier:** [placeholder]
**2) BRDF Datasets for MATLAB Pipeline:** [placeholder]

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
- Finds optimal sample locations given the sample count obtained from 2️⃣ (Note that this script uses FROST-BRDF sampling technique as an example, but any other technique such as Nielse et al.'s can be used at this stage).

### 4️⃣ classification_200x200.ipynb
Open and run the Jupyter notebook:
```
classification_200x200.ipynb
```
- Trains and evaluates a classifier on image data (200×200 patches or configured size).
- Uses the adaptive sampling results for training and validation.

### 5️⃣ runClassRecon.m
```matlab
runClassRecon
```
- Reconstructs BRDFs in the testing set based on the classification result
- Saves reconstructed BRDF files and evaluation metrics.

## 📄 Citation
If you use this code, please cite:

> **Adaptive Sampling for BRDF Acquisition**  
> *Behnaz Kavoosighafi, Saghi Hajisharif, Jonas Unger, and Ehsan Miandji*  
> Under Review (2025)

```bibtex
@inproceedings{Kavoosighafi2025AdaptiveBRDF,
  title     = {Adaptive Sampling for BRDF Acquisition},
  author    = {Behnaz Kavoosighafi and Saghi Hajisharif and Jonas Unger and Ehsan Miandji},
  booktitle = {Under Review},
  year      = {2025}
}






