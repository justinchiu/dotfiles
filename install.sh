#!/bin/bash

set -e

echo "Installing dotfiles dependencies..."

# NVM installation
install_nvm() {
    echo "Installing NVM..."
    if [ -d "$HOME/.nvm" ]; then
        echo "NVM already installed, skipping..."
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi

    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Node.js and npm installation via NVM
install_node() {
    echo "Installing Node.js (LTS) via NVM..."
    if command -v node &> /dev/null; then
        echo "Node.js already installed: $(node --version)"
    else
        nvm install --lts
        nvm use --lts
    fi
    echo "npm version: $(npm --version)"
}

# Claude Code installation
install_claude_code() {
    echo "Installing Claude Code..."
    if command -v claude &> /dev/null; then
        echo "Claude Code already installed: $(claude --version 2>/dev/null || echo 'installed')"
    else
        curl -fsSL https://claude.ai/install.sh | bash
    fi
}

# OpenAI Codex CLI installation
install_codex() {
    echo "Installing OpenAI Codex CLI..."
    if command -v codex &> /dev/null; then
        echo "Codex already installed"
    else
        npm install -g @openai/codex
    fi
}

# AWS CLI installation
install_awscli() {
    echo "Installing AWS CLI..."
    if command -v aws &> /dev/null; then
        echo "AWS CLI already installed: $(aws --version)"
    else
        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -q -o awscliv2.zip
        if command -v sudo &> /dev/null; then
            sudo ./aws/install --update
        else
            ./aws/install --update
        fi
        rm -rf awscliv2.zip aws
    fi
}

# uv installation
install_uv() {
    echo "Installing uv..."
    if command -v uv &> /dev/null; then
        echo "uv already installed: $(uv --version)"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
}

# Ensure ~/.local/bin is on PATH (claude, uv, etc. install there)
ensure_local_bin_on_path() {
    local line='export PATH="$HOME/.local/bin:$PATH"'
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        [ -f "$rc" ] || continue
        if ! grep -qF "$line" "$rc"; then
            echo "Adding ~/.local/bin to PATH in $rc"
            printf '\n# Added by dotfiles/install.sh\n%s\n' "$line" >> "$rc"
        fi
    done
    export PATH="$HOME/.local/bin:$PATH"
}

# Run installations
install_nvm
install_node
install_claude_code
install_codex
install_uv
install_awscli
ensure_local_bin_on_path

if command -v sudo &> /dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y kakoune tmux
else
    apt-get update -y
    apt-get install -y kakoune tmux
fi

pushd $HOME
[ -d dotfiles ] || git clone ssh://git@github.com/justinchiu/dotfiles
cp ~/dotfiles/.tmux.* ~/
mkdir -p ~/.config/kak
cp dotfiles/kakrc ~/.config/kak/kakrc
popd

echo ""
echo "Installation complete!"
echo "Note: You may need to restart your shell or run 'source ~/.bashrc' (or ~/.zshrc) to use nvm."
