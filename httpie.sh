#!/usr/bin/env bash

# httpie.org is useful for getting the headers of suspicious websites. Used for Webshrinker recategorizations.

# install pip
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

# install httpie
pip install --upgrade httpie
