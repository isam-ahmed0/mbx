FROM accetto/xubuntu-vnc-novnc:latest

USER root

# Add your custom wallpaper (make sure you put it beside this Dockerfile)
COPY your_wallpaper.jpg /usr/share/backgrounds/custom_wallpaper.jpg

# Set XFCE wallpaper to your image
RUN xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /usr/share/backgrounds/custom_wallpaper.jpg

# Install Brave browser
RUN apt-get update && apt-get install -y \
    apt-transport-https curl \
    && curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser.list \
    && apt-get update && apt-get install -y brave-browser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5901 6901

CMD [ "/startup.sh" ]
