#!/bin/bash
while true; do

inotifywait -e modify,create,delete -r src && \
zigmach build

done
