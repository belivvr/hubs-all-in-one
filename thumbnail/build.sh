set -ex
cd "$(dirname "$0")"
docker build -t thumbnail .
