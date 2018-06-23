#!/usr/bin/env bash

## Upload a directory or file
SOURCE=$1
REMOTE_DIR=https://crunchbase.file.core.windows.net/master/

if [ -e "$SOURCE" ]; then
    if [ -f "$SOURCE" ]; then
        echo "Uploading file to $REMOTE_DIR..."
        azcopy \
            --source $1 \
            --destination https://crunchbase.file.core.windows.net/master/ \
            --dest-key SvoIubqvfNIyRre/BIUvMkCOplduiprU4VVf6HPi4Dg/aZ3RzNXVy1xT/eLBrEtQGIdQouQt2SN9z/AAa6Z/wQ== \
            --verbose
        echo "Done!"
    fi
    if [ -d "$SOURCE" ]; then
        echo "Uploading folder to $REMOTE_DIR..."
        azcopy \
            --source $1 \
            --destination https://crunchbase.file.core.windows.net/master/ \
            --dest-key SvoIubqvfNIyRre/BIUvMkCOplduiprU4VVf6HPi4Dg/aZ3RzNXVy1xT/eLBrEtQGIdQouQt2SN9z/AAa6Z/wQ== \
            --recursive
            --verbose
        echo "Done!"
    fi
fi