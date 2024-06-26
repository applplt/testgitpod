FROM ubuntu

RUN apt-get update \
    && apt-get install -y \
    curl \
    git \
    golang \
    sudo \
    vim \
    wget \
    direnv \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Install mise
RUN curl https://mise.run | sh

# Append the mise activation script to .zshrc
#RUN echo 'eval "$(/home/${USER}/.local/bin/mise activate zsh)"' >> /home/${USER}/.zshrc