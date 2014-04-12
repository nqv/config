#!/usr/bin/env python
# Required: python-mutagen
import sys, os
import re
import logging
import argparse
import unicodedata
import string
from mutagen.id3 import ID3

def toAscii(data):
    return "".join(x for x in unicodedata.normalize("NFKD", data) \
        if x in string.printable)

# Get string value of a frame
def getText(id3, frameName):
    frames = id3.getall(frameName)
    if not frames or not frames[0].text:
        return None
    return toAscii(frames[0].text[0]).strip()

# Do rename a mp3 file
class Mp3Renamer:
    def __init__(self):
        self.baseDir = None
        self.dryRun = False
        self.fileExt = ".mp3"
        self.nonAllowableChars = "[^A-Za-z0-9()\\[\\]'&\\.,!-]+"

    # Replace non-ascii chars
    def sanitize(self, name):
        return re.sub(self.nonAllowableChars, "_", str(name));

    # Generate directory path from id3 info
    def getDirName(self, id3):
        band = getText(id3, "TPE2")
        album = getText(id3, "TALB")
        year = getText(id3, "TDRC")
        logging.debug("Band: %s, Album: %s, Year: %s", band, album, year)

        if band is None or album is None or year is None:
            return None

        dirName = self.sanitize(album)
        if year is not None:
            dirName = "{}-{}".format(year, dirName)

        return os.path.join(self.sanitize(band), dirName)

    # Generate file name from id3 info
    def getFileName(self, id3):
        trackNum = getText(id3, "TRCK")
        title = getText(id3, "TIT2")
        logging.debug("Title: %s, Track: %s", title, trackNum)

        if title is None:
            return None

        baseName = self.sanitize(title)
        if trackNum is not None:
            # Extract from No/Total format
            trackNum = trackNum.split("/")[0]
            baseName = "{}-{}".format(trackNum.zfill(2), baseName)
        else:
            logging.warn("Track number is not available in %s", title)

        return baseName

    def renameFile(self, filePath):
        fileName, fileExt = os.path.splitext(filePath)
        if fileExt != self.fileExt:
            logging.info("Skip: %s", filePath)
            return
        filePath = os.path.abspath(filePath)
        logging.info("Processing: %s", filePath)

        try:
            id3 = ID3(filePath)
        except:
            logging.warn("Could not load id3 data from %s", filePath)
            return

        # Use current file directory
        if self.baseDir is None:
            dirName = os.path.dirname(filePath)
        else:
            dirName = self.getDirName(id3)
            if dirName is None:
                # Keep current file directory
                dirName = os.path.dirname(filePath)
                logging.info("Keep current file directory: %s", dirName)
            else:
                dirName = os.path.join(self.baseDir, dirName)

        fileName = self.getFileName(id3)
        if fileName is None:
            fileName = os.path.basename(filePath)
            logging.info("Keep current file name: %s", fileName)
        else:
            # getBaseName does not include file extension
            fileName = fileName + fileExt

        newFilePath = os.path.abspath(os.path.join(dirName, fileName))

        if os.path.exists(newFilePath):
            if newFilePath == filePath:
                print("No changes: {}".format(filePath))
            else:
                print("File exists: {}".format(newFilePath))
            return

        print("- {}\n+ {}".format(filePath, newFilePath))
        if not self.dryRun:
            # Create one if not exist
            if not os.path.isdir(dirName):
                os.makedirs(dirName)
            os.rename(filePath, newFilePath)

    def renameDir(self, dirPath, recursive=False):
        files = os.listdir(dirPath)
        files.sort()

        for name in files:
            path = os.path.join(dirPath, name)
            if recursive and os.path.isdir(path):
                self.renameDir(path, recursive)
            elif os.path.isfile(path) and name.endswith(self.fileExt):
                self.renameFile(path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", action='count',
        help="Verbose mode")
    parser.add_argument("-r", "--recursive", action='store_true',
        help="Recursive")
    parser.add_argument("-n", "--noop", action="store_true",
        help="Dry run only")
    parser.add_argument("-d", "--dest", default=None,
        help="Base directory for new files")
    parser.add_argument("file", nargs="+",
        help="MP3 file or directory")

    args = parser.parse_args()

    if args.verbose == 1:
        logging.basicConfig(level=logging.INFO)
    elif args.verbose == 2:
        logging.basicConfig(level=logging.DEBUG)

    renamer = Mp3Renamer()
    renamer.baseDir = args.dest
    renamer.dryRun = args.noop

    for f in args.file:
        if os.path.isdir(f):
            renamer.renameDir(f, args.recursive)
        else:
            renamer.renameFile(f)

