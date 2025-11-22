#!/usr/bin/env bash

# Function that downloads an archive with the source code by the given url,
# extracts its files and exports a variable SOURCES_DIR_${LIBRARY_NAME}
function downloadTarArchive() {
  # The full name of the library
  LIBRARY_NAME=$1
  # The url of the source code archive
  DOWNLOAD_URL=$2
  # Optional. If 'true' then the function creates an extra directory for archive extraction.
  NEED_EXTRA_DIRECTORY=$3

  ARCHIVE_NAME=${DOWNLOAD_URL##*/}
  # File name without extension
  LIBRARY_SOURCES="${ARCHIVE_NAME%.tar.*}"

  echo "Ensuring sources of ${LIBRARY_NAME} in ${LIBRARY_SOURCES}"

  if [[ ! -d "$LIBRARY_SOURCES" ]]; then

    TOTAL_SIZE=$(curl -sI "$DOWNLOAD_URL" | awk '/Content-Length/ {print $2}' | tr -d '\r')

    if [[ -z "$TOTAL_SIZE" ]]; then
        USE_SPINNER=true
    else
        USE_SPINNER=false
    fi

    curl -L --silent "$DOWNLOAD_URL" -o "$ARCHIVE_NAME" &
    CURL_PID=$!

    SPIN=('|' '/' '-' '\\')
    i=0

    while kill -0 "$CURL_PID" 2>/dev/null; do
        if [[ "$USE_SPINNER" = true ]]; then
            i=$(( (i+1) % 4 ))
            echo -ne "\r$ARCHIVE_NAME Downloading: ${SPIN[$i]}"
        else
            if [[ -f "$ARCHIVE_NAME" ]]; then
                CUR_SIZE=$(stat -c%s "$ARCHIVE_NAME" 2>/dev/null)
                PERCENT=$(( CUR_SIZE * 100 / TOTAL_SIZE ))
                echo -ne "\r$ARCHIVE_NAME Progress: ${PERCENT}%"
            fi
        fi
        sleep 0.2
    done

    if [[ "$USE_SPINNER" = true ]]; then
        echo -e "\r$ARCHIVE_NAME Downloading: Done "
    else
        echo -e "\r$ARCHIVE_NAME Progress: 100%"
    fi

    EXTRACTION_DIR="."
    if [ "$NEED_EXTRA_DIRECTORY" = true ] ; then
      EXTRACTION_DIR=${LIBRARY_SOURCES}
      mkdir ${EXTRACTION_DIR}
    fi

    tar xf ${ARCHIVE_NAME} -C ${EXTRACTION_DIR}
    rm ${ARCHIVE_NAME}
  fi

  export SOURCES_DIR_${LIBRARY_NAME}=$(pwd)/${LIBRARY_SOURCES}
}
