# DermatoAI Bachelor Thesis Project: Mobile Application for Image Prediction

This repository contains all the work I completed for my bachelor thesis project. It includes the source code for the mobile app, backend services, and Python scripts used for modeling. Alongside the code, you’ll also find the trained models that achieved the best results, as well as the written thesis (PDF) and the presentation slides (PPT) for the project.

The application is designed as a complete system split into three main components. The mobile app, built with Flutter, allows users to sign up, upload images, and receive real-time updates once predictions are processed. The backend handles all interactions between the app and its features, including managing image uploads to Azure Storage. Finally, the Python worker listens to the Azure Queue, processes the uploaded images, and updates the predictions for the app in real time.

For the modeling, I used pre-trained architectures to develop multi-label classification models and custom-designed models for binary predictions. The models were trained on Google Colab, which provided the computational resources needed to handle the training process.

This repository brings together the technical and research aspects of my thesis, showcasing everything from the app’s functionality to the methods and models behind it.

This is the link to my demo video: [here](https://www.youtube.com/watch?v=W2V31aT8fvQ&ab_channel=AndreiApricopoai)
