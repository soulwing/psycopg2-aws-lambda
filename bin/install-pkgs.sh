#!/bin/bash

sudo apt-get update
sudo apt-get install -y software-properties-common

sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get install -y python${PY_VER}-dev
sudo python3.8 -m pip install --upgrade pip setuptools
