# Use the Gitpod base image
FROM gitpod/workspace-base:2024-06-26-08-49-45

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools and additional packages
RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    nodejs \
    npm \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

# Install zsh and plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/gitpod/.zshrc \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Set up the environment for Homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
ENV PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
ENV HOMEBREW_NO_AUTO_UPDATE=1

# Verify installations
RUN node --version
RUN npm --version
RUN brew --version

# Install yq, jq, mise and direnv using Homebrew
RUN brew install yq jq mise direnv

# Add mise to shell profile
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/mise activate zsh)"' >> /home/gitpod/.zshrc

# Add direnv to shell profile
RUN echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc

# Activate mise for direnv
RUN mkdir -p ~/.config/direnv/lib \
    && mise direnv activate > ~/.config/direnv/lib/use_mise.sh

# Define the command to start zsh
CMD ["zsh"]