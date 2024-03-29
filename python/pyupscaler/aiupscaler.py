#!/usr/bin/env python
# coding=utf-8
#
#   aiuspscaler.py
#       simple upscaler command

import torch
from PIL import Image
import numpy as np
from RealESRGAN import RealESRGAN


class upscaler :

    def __init__(self) :
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model = RealESRGAN(device, scale=4)
        self.model.load_weights('weights/RealESRGAN_x4.pth', download=True)

    def upscaleImage(self, in_path, out_path) :
        image = Image.open(in_path).convert('RGB')
        sr_image = self.model.predict(image)
        sr_image.save(out_path)