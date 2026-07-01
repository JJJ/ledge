# Ledge

> **Light Edge Server**

Ledge bootstraps a fresh Ubuntu LTS server into a secure, reproducible edge gateway.

## Requirements

- Ubuntu 26.04 LTS or newer
- Root SSH access
- Internet connectivity

## Bootstrap

On a brand new server, ssh as `root` and:

    apt update
    apt install -y git

    mkdir -p /opt/ledge
    cd /opt/ledge

    git clone https://github.com/JJJ/ledge.git .

    chmod +x bootstrap.sh configure.sh lock-root.sh

    ./bootstrap.sh

Bootstrap will:

- Update Ubuntu
- Install packages
- Configure automatic updates
- Create the administrator account
- Configure SSH
- Copy the repository to the administrator user's home
- Remove the temporary bootstrap copy

## Continue

Reconnect as the administrator user:

    ssh jjj@<server>

Then:

    cd ~/Development/ledge
    git pull
    sudo ./configure.sh

## Lock root

Once you've verified the administrator account:

    sudo ./lock-root.sh

## Lifecycle

    Fresh Ubuntu
        |
        v
    bootstrap.sh
        |
        v
    ~/Development/ledge
        |
        v
    configure.sh
        |
        v
    lock-root.sh

## Philosophy

- Bootstrap once.
- Configure forever.
- SSH as your administrator, never root.
- Be reproducible.
- Stay cloud agnostic.
