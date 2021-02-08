#!/bin/bash

USERNAME=${USERNAME-vscode}

is_ec2() {
  curl --max-time 1 -s http://169.254.169.254/latest/meta-data/instance-id 2>&1 > /dev/null
  return $?
}

# if in codespaces
if [[ $CODESPACES == 'true' ]]; then
  printf 'ZSH_THEME="clean"\nENABLE_CORRECTION="false"\nplugins=(git virtualenv)\nsource $ZSH/oh-my-zsh.sh' > "/home/$USERNAME/.zshrc"
  # change 'docker' group to gid 800 
  sudo groupmod -g 800 docker
  # add current user to `docker` group
  sudo usermod -a -G docker $USERNAME
  newgrp docker
else 
  if [[ is_ec2 ]]; then
    echo "[INFO] ec2 instance detected"
    # change 'docker' group to gid 992
    sudo groupmod -g 992 docker
    # add current user to `docker` group
    echo "[INFO] sudo usermod -a -G docker $USERNAME"
    sudo usermod -a -G docker $USERNAME
    # as newgrp will create a new shell and the remote container will hang, we don't run the command here
    # newgrp docker
    # add current user to `root` group
    # sudo usermod -a -G root $USERNAME
  fi
  echo "[INFO] update zshrc"
  printf 'ZSH_THEME="powerlevel9k/powerlevel9k"\nENABLE_CORRECTION="false"\nplugins=(git virtualenv)\nPOWERLEVEL9K_MODE="nerdfont-complete"\nPOWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable)\nPOWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs virtualenv)\nsource $ZSH/oh-my-zsh.sh' > "/home/$USERNAME/.zshrc"
fi


echo "exec `which zsh`" > "/home/$USERNAME/.ashrc"
