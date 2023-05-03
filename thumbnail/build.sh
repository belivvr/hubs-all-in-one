!/bin/sh
set -ex
cd "$(dirname "$0")"

rm -rf nearspark
git clone https://github.com/MozillaReality/nearspark.git
cd nearspark

docker build -t thumbnail .
