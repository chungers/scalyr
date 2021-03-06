{{/* =% sh %= */}}

$(sudo scalyr-agent-2 stop)


cat <<EOF > /tmp/agent.json
{{ source `agent.json` }}
EOF
sudo mkdir -p /etc/scalyr-agent-2
sudo cp /tmp/agent.json /etc/scalyr-agent-2

echo "Installing on Scalyr: note this is RHEL only at the moment"

sudo yum install -y wget
wget -q https://www.scalyr.com/scalyr-repo/stable/latest/install-scalyr-agent-2.sh
sudo bash ./install-scalyr-agent-2.sh --set-api-key "{{ var `apiKey` }}" --start-agent

sudo scalyr-agent-2 start
