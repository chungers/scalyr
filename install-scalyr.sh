{{/* =% sh %= */}}

{{ $apiKey := flag "api-key" "string" "api key" | prompt "API key?" "string" "0ySRtj7FVbL1CPxQFcP4Qna0yrpVJYWo7bXwfzSE3Jcw-" }}

echo "Installing on Scalyr: note this is RHEL only at the moment"

sudo yum install -y wget
wget -q https://www.scalyr.com/scalyr-repo/stable/latest/install-scalyr-agent-2.sh
sudo bash ./install-scalyr-agent-2.sh --set-api-key "{{$apiKey}}" --start-agent

{{ var `apiKey` $apiKey}}{{/* sets a variable for sourced template */}}
echo <<EOF > /etc/scalyr/agent.json
{{ source `agent.json` }}
EOF

sudo scalyr-agent-2 start
