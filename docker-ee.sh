{{/* =% sh %= */}}

echo "Running Docker EE installer script"

{{ source `https://s3-us-west-2.amazonaws.com/internal-docker-ee-builds/install.sh` }}
