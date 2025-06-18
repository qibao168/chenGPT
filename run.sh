#!/bin/bash
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi
pip3 install -r requirements.txt
python3 server.py
