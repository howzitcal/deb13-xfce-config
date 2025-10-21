#!/bin/bash

DOWNLOAD_PATH=$HOME/Downloads/tmp
mkdir -p $DOWNLOAD_PATH

sudo apt-get update
sudo apt-get upgrade -yq

sudo add-apt-repository ppa:touchegg/stable
sudo apt-get remove -yq exfalso firefox-esr parole quodlibet synaptic xterm xfburn xfce4-terminal xsane mousepad
sudo apt install -yq gnome-calendar vlc gnome-software gnome-software-plugin-flatpak terminator ca-certificates geany curl gnupg2 wget gpg apt-transport-https papirus-icon-theme touchegg

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --noninteractive -y org.gtk.Gtk3theme.Adwaita-dark
sudo flatpak override --env=GTK_THEME=Adwaita-dark

wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $DOWNLOAD_PATH/chrome.deb
sudo apt-get install -yq $DOWNLOAD_PATH/chrome.deb

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt-get update
sudo apt-get install -yq code docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface accent-color 'blue' #future
gsettings set org.gnome.desktop.interface monospace-font-name 'Jetbrains Mono 13'

mkdir -p $DOWNLOAD_PATH/xfce-config
wget -c https://raw.githubusercontent.com/howzitcal/deb13-xfce-config/refs/heads/main/files/xfce-config.tar.gz -O $DOWNLOAD_PATH/xfce-config/release.tar.gz

xfce4-panel -q && pkill xfconfd

(
    cd $DOWNLOAD_PATH/xfce-config/
    tar -xf release.tar.gz
    cp -vrf ./release/.wallpapers $HOME    
    cp -vrf ./release/.fonts $HOME    
    cp -vrf ./release/xfce4 $HOME/.config
)

for p in $(xfconf-query -c xfce4-desktop -l | grep last-image); do
  xfconf-query -c xfce4-desktop -p "$p" -s $HOME/.wallpapers/white-pony-cdf.webp
done




