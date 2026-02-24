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

# uv installation
install_uv() {
    echo "Installing uv..."
    if command -v uv &> /dev/null; then
        echo "uv already installed: $(uv --version)"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
}

# Run installations
install_nvm
install_node
install_claude_code
install_codex
install_uv

if command -v sudo &> /dev/null; then
    sudo apt-get install -y kakoune tmux
else
    apt-get install -y kakoune tmux
fi

[ -d dotfiles ] || git clone ssh://git@github.com/justinchiu/dotfiles
cp dotfiles/.tmux.* ~/
mkdir -p ~/.config/kak
cp dotfiles/kakrc ~/.config/kak/kakrc

echo ""
echo "Installation complete!"
echo "Note: You may need to restart your shell or run 'source ~/.bashrc' (or ~/.zshrc) to use nvm."
