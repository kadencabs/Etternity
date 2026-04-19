#!/usr/bin/env python3
"""
Symbol Prepare
Takes the Etternity.sym file, and creates a google breakpad directory structure.
Creates to simplify use when uploading to action artifacts.
"""
import os
import sys
import shutil
from pathlib import Path


def get_metadata(filename: str):
    """Read first line to get relevant file data"""
    with open(filename, 'r') as f:
        first_line = f.readline().strip()   # Remove newline
    first_line = first_line.split(' ')  # Split by spaces
    return first_line[3], first_line[4]


def make_breakpad_directory():
    build_uuid, module_id = get_metadata('Etternity.sym')
    path = Path("EtternitySymbolsUploadDir", "EtternitySymbols", module_id, build_uuid)
    os.makedirs(path, exist_ok=True)
    shutil.copyfile('Etternity.sym', path / 'Etternity.sym')


make_breakpad_directory()
sys.exit(0)
