#!/usr/bin/env python
# coding=utf-8
#
#   progress.py
#       handle progress of ffmpeg commands

import re
import datetime
import math 

# static constants
_dur_re = re.compile(r".*Duration:\W*(\d+):(\d+):(\d+)\.(\d+),.*")
_fra_re = re.compile(r".*frame=\W*(\d+)")
_tim_re = re.compile(r".*time=\W*(\d+):(\d+):(\d+)\.(\d+)")

class FFMPEGDuration  : 
    """
        time delta name tuples
    """
    def __init__(self, timestamp : tuple) :
        # timestamp is a tuple of hours, minutes, sec, centi
        hms = timestamp
        self.hours, self.minutes, self.seconds, self.milliseconds = map (lambda x : int(x), list(hms) )
    def __repr__(self) :
        return (f"{self.hours}:{self.minutes}:{self.seconds}.{self.milliseconds}")
    def __div__(self, other) :
        return self.total_seconds() / other.total_seconds()
    def total_seconds():
        return (self.hours * 60 + self.minutes) * 60 + self.seconds + (self.milliseconds / 1000)


## parse ffmpeg output
class FFMPEGOutput :

    def __init__(self, clear_new_frame = False) :
        self.clear_new_frame = clear_new_frame
    
    def parse(self, stderr, stdout):
        lines =  map(lambda x : x.readline().decode('utf-8').strip(), [stdout, stderr])
        for line in lines :
            try : 
                dr = list(_dur_re.findall(line)[0])
                dr[3] += '0'
                d = FFMPEGDuration(timestamp= dr)
            except IndexError : pass
            else : self.duration = d
            try : 
                tr = list(_tim_re.findall(line)[0])
                tr[3] = str(int(round(float(tr[3]) / 1000)))
                t = FFMPEGDuration(timestamp = tr)
            except IndexError : pass
            else : self.timecode = t
            try : f = _fra_re.findall(line)[0]
            except IndexError : pass
            else : self.frame = f
    
    @property
    def progress(self) : 
        try : 
            return timecode / duration
        except: 
            return 0 


class ProgressBar :
    
    def __init__(self, bar_length, output : FFMPEGOutput = None) :
        self.bar_length = bar_length
        self.output = output if output != None else FFMPEGOutput()

    def progress(self, stdout, stderr) :
        self.output.parse(stdout, stderr)
        try : 
            percent = min(1.0, max(0.0, self.output.progress))
            bar = '#' * int(percent *self.bar_length) +  '-' * int((1 - percent) * self.bar_length)
            print(f"\rprogress = {round(percent * 100, 2)}% [{bar}] (frame={self.output.frame})", end="")
        except Exception as E :
            print(f"error : {E.__class__.__name__} , {E}")
            pass
    
    def end(self) :
        print("\n")