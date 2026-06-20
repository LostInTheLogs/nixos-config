# <https://den.denful.dev/reference/schema/>
{
  lib,
  den,
  ...
}: {
  # enable hm by default
  # den.schema.user.classes = lib.mkDefault ["homeManager"];
  den.schema.user = {
    config.classes = lib.mkDefault ["homeManager"];
  };
}
