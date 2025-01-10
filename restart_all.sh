#!/bin/bash
cd "$(dirname "$0")"

# Use the ENV environment variable if set, otherwise use the first argument
ENV_FILE="${ENV:-$1}"
OPTION="$2"

# Print usage if no parameters are provided
if [ -z "$ENV_FILE" ]; then
    echo "Usage: $0 ENV_FILE [OPTION]"
    echo "OPTION:"
    echo "  dialog  - Run dialog only"
    echo "  hubs    - Run hubs only"
    echo "  (none)  - Run both hubs and dialog"
    exit 1
fi

bash clean_all.sh

# Check if the environment configuration file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Source the environment configuration file
source "$ENV_FILE"
source ./functions.sh

docker network create haio || true

# Run dialog if no parameter or if 'dialog' is specified
if [ -z "$OPTION" ] || [ "$OPTION" == "dialog" ]; then
    bash dialog/run.sh
fi

# Run everything except dialog if no parameter or if 'hubs' is specified
if [ -z "$OPTION" ] || [ "$OPTION" == "hubs" ]; then
    bash db/run.sh "$ENV_FILE"
    bash reticulum/run.sh
    bash hubs/run.sh
    bash hubs/admin/run.sh
    bash spoke/run.sh
    bash postgrest/run.sh "$ENV_FILE"
    bash thumbnail/run.sh
    bash proxy/run.sh "$ENV_FILE"
fi

# Example of using an environment variable
echo "Running with HUBS_HOST: $HUBS_HOST"

if [ "$OPTION" = "dialog" ]; then
    docker logs -f dialog
else    
    docker logs -f reticulum
fi

