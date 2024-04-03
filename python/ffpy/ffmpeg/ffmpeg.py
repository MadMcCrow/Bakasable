#!/usr/bin/env python
# coding=utf-8
#
#   ffmpeg.py
#       simple ffmpeg commands

# imports
import shutil, shlex, subprocess, json, os, math
from shlex import split
from decimal import Decimal

# local import
from ffmpeg import ffprobe


def _command(inputs, options, output ) :
    """
        build a command call for FFmpeg
        inputs are a list of paths but can also have options
        like inputs = ["-ss 10 -i myfile.mov"]
    """
    options = f"{options}"
    cmd = f"ffmpeg {' '.join(inputs)} {options} {output}"
    return shlex.split(cmd)

def mux(video, audio, output) :
    """
        mix inputs
    """
    pass
    

def images(path, out, start_ms = None, end_ms = None) :
    """
        extract images between start and end or end of file
    """
    # output filename : 
    dname = os.path.dirname(out)
    fname, ename = os.path.splitext(os.path.basename(out))
    # get info from file
    probe    = ffprobe.Probe(path)
    if start_ms is not None:
        if end_ms is not None :
            duration = Decimal(start_ms - end_ms) / Decimal('1000')
        else :
            duration = probe.seconds() 
            - (Decimal(start_ms) / Decimal('1000'))
    else :
        duration = probe.seconds()

    frate    = probe.framerate()
    # get number of frames
    dectuple = (duration * frate).as_tuple()
    dnum = (len(dectuple.digits) + dectuple.exponent) + 1

    outname = f'{fname}_%0{dnum}d.png'
    outpath = fr'\"{os.path.join(dname,outname)}\"'

    # time stamps :
    to_str = f"-to {end_ms}ms" if end_ms is not None else ""
    ss_str = f"-ss {start_ms}ms" if start_ms is not None else ""
    input_str = fr'{ss_str} {to_str} -i \"{path}\"'
    
    cmd = _command([input_str], "", outpath)
    print (' '.join(cmd))
    subprocess.Popen(cmd, text=True)
    # Command.__init__(self, file_input, output, "")