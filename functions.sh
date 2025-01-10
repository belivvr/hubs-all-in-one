#!/bin/bash

# Use the ENV environment variable if set, otherwise use the first argument
ENV_FILE="${ENV:-$1}"

# Check if the environment configuration file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Environment file '$ENV_FILE' not found."
  exit 1
fi

# Source the environment configuration file
source "$ENV_FILE"

function replace_vars_in_files() {
    FILE=$1

    for var in $(compgen -v); do
        VALUE=${!var}
        sed -i "s/\${${var}}/${VALUE//\//\\/}/g" $FILE
    done
}

function cp_and_replace() {
    TEMPLATE=$1
    FILE=$2
    echo "Copying template: $TEMPLATE to $FILE and replacing variables"

    cp $TEMPLATE $FILE

    # Extract variables from the template file
    VARIABLES=$(grep -oP '\$\{\K[^}]+' "$TEMPLATE")

    for var in $VARIABLES; do
        VALUE=${!var}
        # Escape special characters in VALUE
        ESCAPED_VALUE=$(printf '%s\n' "$VALUE" | sed 's/[&/\]/\\&/g')
        echo "Variable: ${var}, Value: ${ESCAPED_VALUE}"
        echo "Replacing \${${var}} with ${ESCAPED_VALUE} in $FILE"
        sed -i "s|\${${var}}|${ESCAPED_VALUE}|g" $FILE
    done
}

function add_env_var_to_file() {
    local env_var_name=$1
    local file_name=$2
    local formatted_string=$3
    local env_var_value=$(printenv "$env_var_name")

    if [ ! -z "$env_var_value" ]; then
        # Evaluate and replace the environment variable value in the formatted string
        local to_add=$(eval echo "$formatted_string")
        echo "$to_add" >> "$file_name"
    fi
}