{pkgs, ...}: {
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "pl_PL.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_TIME = "en_GB.UTF-8";
  };

  environment.systemPackages = with pkgs; [hunspell hunspellDicts.pl_PL hunspellDicts.en_US hunspellDicts.en_GB-ise hunspellDicts.en_GB-ize];
}
