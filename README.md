# Running test vm

```sh
nix run ".#nixosConfigurations.testVm.config.system.build.customVm"
```

# Credits

## Special thanks

- [**NotAShelf/nyx**](https://github.com/NotAShelf/nyx) - I mostly based my configuration on this config. Thank you @NotAShelf for providing such an awesome resourse for free.

## Other resources

Configs I read through and **tried** to understand before writing this config:

- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [EdenEast/nyx](https://github.com/EdenEast/nyx/blob/3c22dbe5a033c95292e4f5e98c132e85f7b8af23/lib/default.nix)

- [jecaro/simple-nix-vm](https://github.com/jecaro/simple-nix-vm),
  [tobiasBora's nixos discourse](https://discourse.nixos.org/t/get-qemu-guest-integration-when-running-nixos-rebuild-build-vm/22621),
  [spice's manual](https://www.spice-space.org/spice-user-manual.html#agent) - clipboard sharing in the test vm

## Official manuals

- [Nix Manual](https://nix.dev/manual/nix)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)
