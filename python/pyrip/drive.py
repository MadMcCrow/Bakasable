#!/usr/bin/env python
# coding=utf-8
#
#   drive.py
#       how to addres disk drives

# system import
import subprocess
import os
import stat


# private constants
_DRIVE_EJECT_TRIES = 500
_DRIVE_EJECT_WAIT  = 0.10




class Drive :
    """
        Drive class represent the actual device
    """

    def __init__(self, mountpoint, mount_timeout=0):
        if stat.S_ISBLK(os.stat(mountpoint).st_mode):
            mountpoint = FindMountPoint(mountpoint, mount_timeout)
        if not os.path.isdir(mountpoint):
            raise UserError('%r is not a directory' % mountpoint)
        self.mountpoint = mountpoint

    def eject(self) :
        """
            open dvd drive
        """
        if os.name == 'nt':
            if len(self.mountpoint) < 4 and self.mountpoint[1] == ':':
                # mountpoint is only a drive letter like "F:" or "F:\" not a subdirectory
                drive_letter = self.mountpoint[0]
                ctypes.windll.WINMM.mciSendStringW("open %s: type CDAudio alias %s_drive" % (drive_letter, drive_letter), None, 0, None)
                ctypes.windll.WINMM.mciSendStringW("set %s_drive door open" % drive_letter, None, 0, None)
            return
        for i in range(_DRIVE_EJECT_TRIES) :
            if not subprocess.call(['eject', self.mountpoint]):
                break
            time.sleep(_DRIVE_EJECT_WAIT )

    @classmethod
    def listdrives() :
        """
            find all drives on this devices
        """
        # TODO : windows
        if os.name == 'nt':
            print(subprocess.Popen("fsutil fsinfo drives").readlines())
            return
        
