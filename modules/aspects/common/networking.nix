{
  den.aspects.common.nixos = {...}: {
    networking.networkmanager.enable = true;
    services.resolved.enable = true;
  };
}
