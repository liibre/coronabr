#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
from setuptools import setup, find_packages

setup(
    name="covid19br",
    version="0.1.0",
    packages=find_packages(),
    py_modules=['covid19br'],
    license="GPL",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Topic :: Utilities",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
    ], )