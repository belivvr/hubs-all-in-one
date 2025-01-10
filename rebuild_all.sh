#!/bin/bash
cd "$(dirname "$0")"

# Use the ENV environment variable if set, otherwise use the first argument
ENV_FILE="${ENV:-$1}"
OPTION="$2"

# Print usage if no parameters are provided
if [ -z "$ENV_FILE" ]; then
    echo "Usage: $0 ENV_FILE [OPTION]"
    echo "OPTION:"
    echo "  dialog  - Build and run dialog only"
    echo "  hubs    - Build and run hubs only"
    echo "  (none)  - Build and run both hubs and dialog"
    exit 1
fi

# Check if the environment configuration file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Source the environment configuration file
source "$ENV_FILE"

bash clone_all.sh "$ENV_FILE" "$OPTION"


# Build dialog if no second parameter or if 'dialog' is specified
if [ -z "$OPTION" ] || [ "$OPTION" == "dialog" ]; then
    bash dialog/build.sh
fi

# Build everything except dialog if no second parameter or if 'hubs' is specified
if [ -z "$OPTION" ] || [ "$OPTION" == "hubs" ]; then
    bash postgrest/build.sh
    bash hubs/build.sh
    bash hubs/admin/build.sh 
    bash spoke/build.sh 
    bash thumbnail/build.sh 
    bash reticulum/build.sh
fi

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

bash restart_all.sh "$ENV_FILE" "$OPTION"