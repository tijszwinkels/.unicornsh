#!/bin/sh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if sgpt is installed
if ! command_exists sgpt; then
    echo "Error: sgpt is not installed. Please install shell_gpt first."
    echo "Visit https://github.com/TheR1D/shell_gpt for installation instructions."
    exit 1
fi

# Determine the user's login shell
USER_SHELL=$(basename "$SHELL")

case "$USER_SHELL" in
    zsh)
        RCFILE="$HOME/.zshrc"
        ;;
    bash)
        RCFILE="$HOME/.bashrc"
        ;;
    *)
        echo "Unsupported shell ($USER_SHELL). Please add the following lines manually to your shell's rc file:"
        echo "### BEGIN .unicornsh"
        echo "source ~/.unicornsh/unicornsh.source"
        echo "### END .unicornsh"
        exit 1
        ;;
esac

# Check if .unicornsh is already installed
if grep -q "### BEGIN .unicornsh" "$RCFILE"; then
    echo ".unicornsh is already installed. Skipping rc file modification."
else
    # Add guarded source line and PATH update to the appropriate rc file
    echo "### BEGIN .unicornsh" >> "$RCFILE"
    echo "source ~/.unicornsh/unicornsh.source" >> "$RCFILE"
    echo 'export PATH="$PATH:$HOME/.unicornsh/scripts"' >> "$RCFILE"
    echo "### END .unicornsh" >> "$RCFILE"
    echo "Added .unicornsh configuration to $RCFILE"

    # Add symlink
    ln -s ~/.unicornsh ~/.🦄sh
fi

# Install sgpt functions
sgpt --install-functions

# Remove existing functions directory and create symlink
rm -rf ~/.config/shell_gpt/functions && ln -s ~/.unicornsh/functions ~/.config/shell_gpt/functions

echo "Installation complete! Please restart your shell or run 'source $RCFILE' to apply changes."
