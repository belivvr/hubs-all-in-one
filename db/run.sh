#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# Load the .env file based on the current directory
cd ..

# Get the environment file from the first parameter
ENV_FILE="$1"

# Check if the environment file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Environment file '$ENV_FILE' not found."
  exit 1
fi

# Source the environment file
source "$ENV_FILE"

cd $THISDIR

# If the port is in use, the following error will occur.
# 2023-04-05 07:28:34.603 UTC [152] FATAL:  password authentication failed for user "postgres"
# 2023-04-05 07:28:34.603 UTC [152] DETAIL:  Password does not match for user "postgres".
#         Connection matched pg_hba.conf line 95: "host all all all md5"

docker rm -f db

sudo mkdir -p "$DB_VOLUME_DIR"
if [ "$ENV_FILE" = "prod" ]; then
  echo "mount is not execute for azure migration"
  # sudo mount -t nfs $DB_NAS_LOCATION $DB_VOLUME_DIR
  # Keep mount information (fstab setting)
  # echo "$DB_NAS_LOCATION $DB_VOLUME_DIR nfs ,defaults 0 0" | sudo tee -a /etc/fstab
fi

docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always -p 5432:5432 --name db -e POSTGRES_PASSWORD="$DB_PASSWORD" -v "$DB_VOLUME_DIR":/var/lib/postgresql/data postgres:11-bullseye || true
container_name="db"
log_message="listening on IPv4 address \"0.0.0.0\", port 5432"

while ! docker logs "$container_name" 2>&1 | grep -q "$log_message"; do
  sleep 1
done

# Check if the ret_dev database already exists
db_exists=$(docker exec db psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='ret_dev'")

if [ "$db_exists" != "1" ]; then
  # Execute commands only if the ret_dev database does not exist
  docker exec db psql -U postgres -c "CREATE DATABASE ret_dev;"
  docker exec db psql -U postgres -d ret_dev -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
  docker exec db psql -U postgres -d ret_dev -c "ALTER USER $DB_USER WITH SUPERUSER;"
  docker exec db psql -U postgres -d ret_dev -c "GRANT ALL PRIVILEGES ON DATABASE ret_dev TO $DB_USER;"
  docker exec db psql -U postgres -d ret_dev -c "GRANT CREATE ON DATABASE ret_dev TO $DB_USER;"
else
  echo "Database 'ret_dev' already exists. Skipping database initialization."
fi
