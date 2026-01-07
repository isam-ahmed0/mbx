FROM accetto/xubuntu-vnc-novnc:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Lightweight wallpaper
COPY Pl6QHc.webp /usr/share/backgrounds/custom_wallpaper.jpg

# Install essentials: Brave, VS Code, lightweight UI themes, and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https curl software-properties-common \
    xfce4-settings lightdm lightdm-gtk-greeter \
    arc-theme papirus-icon-theme \
    pulseaudio alsa-utils \
    vim-tiny htop git wget sudo bash-completion \
    fonts-firacode fonts-powerline fonts-font-awesome \
    xclip xsel \
    && curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser.list \
    && apt-get update && apt-get install -y --no-install-recommends brave-browser \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y code \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set XFCE wallpaper
RUN xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /usr/share/backgrounds/custom_wallpaper.jpg

# Configure XFCE UI settings: theme, icons, fonts, cursor
RUN xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Dark && \
    xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Dark && \
    xfconf-query -c xsettings -p /Gtk/FontName -s "Fira Code Regular 11" && \
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "capitaine-cursors"

EXPOSE 5901 6901

CMD ["/startup.sh"]
