# nixos-config

please tell me how to make better, thanks 🙏🙏🙏  
(no need to be polite)  

### install instructions:
1. git pull the repo in user's home dir
2. put configuration.nix into /etc/nixos
3. nixos-rebuild switch
4. move hardware-configuration.nix from /etc/nixos to here
4. from now can use normally:
```
sudo nixos-rebuild switch --flake ~/nixos-config
home-manager switch --flake ~/nixos-config
```
