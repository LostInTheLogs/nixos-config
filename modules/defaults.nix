# <https://den.denful.dev/reference/schema/>
{den, ...}: {
  den.default = {
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.inputs'
      den.batteries.self'
    ];
  };
}
