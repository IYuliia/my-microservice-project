#!/bin/bash

# Функція для перевірки, чи команда існує
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "🔧 Починаю встановлення необхідних інструментів..."

# Docker
if command_exists docker; then
    echo "✅ Docker вже встановлено"
else
    echo "⬇️ Встановлюю Docker..."
    sudo apt update
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo usermod -aG docker "$USER"
    echo "✅ Docker встановлено"
fi

# Docker Compose
if docker compose version &>/dev/null; then
    echo "✅ Docker Compose вже встановлено"
else
    echo "⬇️ Встановлюю Docker Compose..."
    sudo apt install docker-compose -y
    echo "✅ Docker Compose встановлено"
fi

# Python
if command_exists python3; then
    PYTHON_VERSION=$(python3 -V | cut -d " " -f 2)
    if [[ "$PYTHON_VERSION" > "3.8" ]]; then
        echo "✅ Python $PYTHON_VERSION вже встановлено"
    else
        echo "⚠️ Потрібна новіша версія Python. Встановлюю Python 3.9..."
        sudo apt update
        sudo apt install -y python3.9 python3.9-venv python3.9-dev python3-pip
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
    fi
else
    echo "⬇️ Встановлюю Python..."
    sudo apt update
    sudo apt install -y python3 python3-pip
    echo "✅ Python встановлено"
fi

# Django
if python3 -m django --version &>/dev/null; then
    echo "✅ Django вже встановлено"
else
    echo "⬇️ Встановлюю Django..."
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo "✅ Django встановлено"
fi

echo "🎉 Встановлення завершено!"
