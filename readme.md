# dbatools lifehacks workspace

This is a repo containing a dev container for my dbatools lifehacks demo from PSConfEU 2022.

## PreRequisites

To get this dev container working on your computer you need:

- [Docker](https://www.docker.com/get-started)
- [git](https://git-scm.com/downloads)
- [VSCode](https://code.visualstudio.com/download)
- [`Remote Development` Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

## Setup

1. Download the repo from GitHub

    ```PowerShell
    # change directory to where you'd like the repo to go
    cd C:\GitHub\

    # clone the repo from GitHub
    git clone https://github.com/jpomfret/dbatoolsLifehacks.git

    # move into the folder
    cd .\dbatoolsLifehacks\

    # open VSCode
    code .
    ```

2. Once code opens, there should be a toast in the bottom right that suggests you 'ReOpen in Container'.
3. The first time you do this it may take a little, and you'll need an internet connection, as it'll download the container images used in our demos
4. Open a pwsh console and start your adventure... (Note it is better in a vanilla pwsh session than in the Integrated Terminal)

## Rebuild the containers

In order to rebuild the environment fully, you need to run the following from a separate window

`docker-compose -f "docker-compose.yml" -p "dbatoolslifehacks_devcontainer" down`
