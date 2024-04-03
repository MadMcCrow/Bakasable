#!/usr/bin/env python
# coding=utf-8
#
#   main.py
#       use ffpy to transcode, analyse and filter video files

import os
from ffmpeg import ffprobe, ffmpeg


movie = "/Volumes/ToshSave/Movies/Movies/Django Unchained.avi"
# path = os.path.abspath(os.path.expanduser(self.path))
target = "../test/Django Unchained"
os.makedirs(os.path.dirname(target), exist_ok=True)

ffmpeg.images(movie, target, start_ms=0, end_ms=1000)
