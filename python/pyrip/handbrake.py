#!/usr/bin/env python
# coding=utf-8
#
#   handbrake.py
#       run handbrake commands

_HANDBRAKE = "HandBrakeCLI" 

def hasHandBrake() :
    return shutil.which(_HANDBRAKE)


