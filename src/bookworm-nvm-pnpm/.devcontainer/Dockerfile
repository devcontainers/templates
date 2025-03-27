# Use Debian Bookworm as the base image
FROM debian:bookworm-slim

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up environment variables
ENV HOME=/home/devuser
ENV NVM_DIR=$HOME/.nvm
ENV PATH=$HOME/.local/bin:$PATH

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    gpg \
    wget \
    unzip \
    build-essential \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash devuser
USER devuser
WORKDIR $HOME

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install the latest LTS Node.js version and set as default
RUN \
    . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm use --lts

# Install PNPM
RUN \
    . "$NVM_DIR/nvm.sh" && \
    npm install -g pnpm

# Add a script to source NVM when starting the container
RUN echo '\
# NVM setup\n\
export NVM_DIR="$HOME/.nvm"\n\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n\
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion\n\
' >> $HOME/.bashrc

# Set the default command
CMD ["/bin/bash"]