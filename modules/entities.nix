# <https://den.denful.dev/explanation/entities/>
# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  # vodfsh user at ocean host.
  den.hosts.x86_64-linux.ocean.users.vodfsh = {};
  den.hosts.x86_64-linux.test-vm.users.vodfsh = {};
  den.homes.x86_64-linux."vodfsh@test-vm" = {};

  den.hosts.x86_64-linux.aquarium.users.vodfsh = {};
}
