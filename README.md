# Getting Started Guide

My nixos config made with [den](https://den.denful.dev).

# Usage

- Build / Switch

  ```console
  # default action is build
  nix run .#<host>

  # pass any other nh action
  nix run .#<host> -- switch

  nix run .#<host> -- boot
  ```

- Running the vm

  See [modules/hosts/test-vm.nix](modules/hosts/run-test-vm.nix)

  ```console
  nix run .#run-test-vm
  ```

# Credits

Before changing to [den](https://den.denful.dev/) I mostly based my configuration on [**NotAShelf/nyx**](https://github.com/NotAShelf/nyx), Thanks @NotAShelf.
