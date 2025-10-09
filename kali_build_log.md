# kali build log

1. install nix:
    `sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon`
2. add nix channels:
    ```shell
     $ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
     $ nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
     ```
3. update channels:
    `nix-channel --update`
4. install home-manager:
    `nix-shell '<home-manager>' -A install`
5. symlink to home config:
    ```shell
    rm -f ~/.config/home-manager/home.nix
    ln -sf $PWD/nix/home.nix $HOME/.config/home-manager/home.nix
    ```
6. install:
    ```shell
    home-manager switch
    ```
7. TODO: install claude code
