#!/usr/bin/env python
# coding=utf-8
#
#   ffprobe.py
#       helper to probe a path

# system import
import shutil, shlex, subprocess, json, os
from shlex import split
from decimal import Decimal
from datetime import timedelta


# TODO : 
#   - use : pathlib.Path
#   - add more useful getters
#   - move to module as class


class Probe :
    """ 
        get ffprobe infos about a file and store them in an object
    """

    def __init__(self, path) :
        self.path = path
        # check that we can ffprobe safely
        if shutil.which("ffprobe") is None:
            raise OSError("ffmpeg not found")
        # check path
        if not os.path.exists(self.path) :
            raise OSError(f"{self.path} does not exists !")
        # create command
        cmd = f"ffprobe -v quiet -print_format json -show_format -show_streams '{self.path}'"
        result = subprocess.run(shlex.split(cmd), stdout = subprocess.PIPE, stderr = subprocess.PIPE, text=True)
        # return dictionary of ffprobe info 
        self.data = json.loads(str(result.stdout))
    
    def video(self) :
        """
            video streams
        """
        retval = []
        for stream in self.data["streams"] :
            if stream["codec_type"] == "video" : 
                retval.append(stream)
        return retval

    def seconds(self) :
        """
            precise seconds expressed in decimals
        """
        return Decimal(self.data["format"]["duration"])

    def milliseconds(self) :
        """
            precise milliseconds expressed in integer
        """
        seconds = Decimal(self.data["format"]["duration"])
        return int((seconds * Decimal('1000')).to_integral())
    
    def duration(self) :
        """
            imprecise duration expressed as a timedelta
        """
        return timedelta(seconds=self.seconds().__float__())

    def framerate(self) :
        """
            search framerate and return it in precise Decimal
        """
        try :
            r_frame_rate = self.data["format"]["r_frame_rate"]
        except : 
            for stream in self.video() :
                if "r_frame_rate" in stream.keys() :
                    r_frame_rate = stream["r_frame_rate"]
                    break
        finally:
            if '/' in r_frame_rate : 
                a,b = r_frame_rate.split('/')
                return Decimal(a)/Decimal(b)
            else :
                return Decimal(r_frame_rate)