{{/* =% sh %= */}}

$(sudo scalyr-agent-2 stop)

{{ $apiKey := flag "scalyr-api-key" "string" "api key" | prompt "Scalyr API key?" "string" "0ySRtj7FVbL1CPxQFcP4Qna0yrpVJYWo7bXwfzSE3Jcw-" }}

{{ var `apiKey` $apiKey}}{{/* sets a variable for sourced template */}}
echo <<EOF > /tmp/agent.json
{{ source `agent.json` }}
EOF
mkdir -p /etc/scalyr-agent-2
sudo cp /tmp/agent.json /etc/scalyr-agent-2/agent.json

echo "Installing on Scalyr: note this is RHEL only at the moment"

sudo yum install -y wget
wget -q https://www.scalyr.com/scalyr-repo/stable/latest/install-scalyr-agent-2.sh
sudo bash ./install-scalyr-agent-2.sh --set-api-key "{{$apiKey}}" --start-agent

sudo scalyr-agent-2 start
