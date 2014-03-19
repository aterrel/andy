#!/usr/bin/env python
"""andy_log -- A module of life logging."""

from __future__ import  __absolute_import__, __print_function__, __division__

import datetime
import os


class AndyLog(object):

    LOG_EXT = ".md"
    CURRENT_ALIAS = "current.md"

    def __init__(self, andy_dir=None):
        if andy_dir:
            self._dir = andy_dir
        else:
            self._dir = os.environ.get("ANDY_DIR")
            if self._dir is None:
                os.path.join(os.environ.get("HOME", '/'), "Dropbox", "log")

    @property
    def dir(self):
        return self._dir

    def get_current_log(self):
        """Returns the path of the most recently updated logfile"""
        logs = filter(lambda x: x.endswith(self.LOG_EXT) and x != self.CURRENT_ALIAS,
                      os.listdir(self.dir))
        logs.sort()
        return logs[-1]

    def convert_log_to_date(self, path):
        _path = path.replace(self.LOG_EXT, '')
        if not _path.isdigit():
            raise ValueError("Log path name is not in YYYYMMDD format. Given: %s" % path)
        year, month, day = _path[:4], _path[4:6], _path[6:]
        try:
            date = datetime.date(year, month, day)
        except ValueError:
            raise ValueError("Log path name is not in YYYYMMDD format. Given: %s" % path)
        return date

    def rotate_log(self):
        """Rotates the log based on number of days in current log."""

        path = self.get_current_log()
        date = self.convert_log_to_date(path)
        days_passed = datetime.date.today() - date
        if days_passed <= 7:
            return
        os.unlink(os.path.join(self._dir, self.CURRENT_ALIAS))
        # Start logs on mondays
        start_date = date - datetime.timedelta(days=date.isoweekday() % 7 + 1)
        new_log_filename = self._dir + start_date.strftime("%Y%m%d") + self.LOG_EXT
        open(new_log_filename)
        os.symlink(new_log_filename, self.CURRENT_ALIAS)

    def add_note(self):



