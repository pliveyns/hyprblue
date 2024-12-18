# vim: set ft=make :

my_install-ssh-keys:
  #!/usr/bin/env bash
  curl http://192.168.148.28:8081/id_rsa.pub --create-dirs -o ~/.ssh/id_rsa.pub
  curl http://192.168.148.28:8081/id_rsa --create-dirs -o ~/.ssh/id_rsa

  chmod 600 ~/.ssh/id_rsa.pub
  chmod 600 ~/.ssh/id_rsa

  if ! ssh-keygen -F github.com; then
    ssh-keyscan github.com >> ~/.ssh/known_hosts
  fi

  if ! ssh-keygen -F gitlab.com; then
    ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
  fi

  chmod 600 ~/.ssh/known_hosts

# Install bluebox toolbox: ghcr.io/pliveyns/bluebox
my_toolbox-bluebox:
  #!/bin/sh
  # should not run if the toolbox already exists
  toolbox list --containers | grep bluebox >& /dev/null
  if [ $? -eq 0 ]
  then
    echo "The toolbx bluebox already exists and will not be installed"
  else
    echo "Installing bluebox toolbx"
    toolbox create -y -i ghcr.io/pliveyns/bluebox -c bluebox
  fi

## Install nvchad
#my_nvchad:
#  #!/bin/sh
#  # First check if nvim folder is not already existing
#  if [ -d ~/.config/nvim/ ]
#  then
#    echo "Directory ~/.config/nvim/ already exists."
#    echo "NvChad will not be installed."
#  else
#    echo "Installing NvChad for nvim"
#    toolbox run --container bluebox git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
#  fi

# Set firefox as default default browser
my_default-browser-firefox:
  xdg-settings set default-web-browser org.mozilla.firefox.desktop

# Run the ansible postinstalscript
my_postinstall:
  curl http://192.168.148.28:8081/bootstrapublue | bash

my_setup-chezmoi:
  systemctl enable --user --now chezmoi-init.service chezmoi-update.timer
