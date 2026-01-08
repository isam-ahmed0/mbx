FROM accetto/ubuntu-vnc-xfce-g3:latest

USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

###############################################################################
# Base tools (minimal)
###############################################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    apt-transport-https \
    git \
    sudo \
    vim-tiny \
    htop \
    fonts-dejavu \
    xclip \
    && rm -rf /var/lib/apt/lists/*

###############################################################################
# Brave Browser (Ubuntu 22.04 compatible)
###############################################################################
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
    https://brave-browser-apt-release.s3.brave.com/ stable main" \
    > /etc/apt/sources.list.d/brave-browser.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends brave-browser \
    && rm -rf /var/lib/apt/lists/*

###############################################################################
# VS Code (22.04+ safe)
###############################################################################
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/repos/code stable main" \
    > /etc/apt/sources.list.d/vscode.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends code \
    && rm -rf /var/lib/apt/lists/*

###############################################################################
# Wallpaper (optional)
###############################################################################
COPY your_wallpaper.jpg /usr/share/backgrounds/custom.jpg

RUN xfconf-query -c xfce4-desktop \
    -p /backdrop/screen0/monitor0/image-path \
    -s /usr/share/backgrounds/custom.jpg || true

###############################################################################
# Ports
###############################################################################
EXPOSE 5901 6901

CMD ["/startup.sh"]
