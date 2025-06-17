{
  lib,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    eza # ls replacement
    fd
    fzf
    ripgrep
    zoxide
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.path = "$XDG_STATE_HOME/zsh/history";
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "EZA_ICON_SPACING=2 eza -a --icons --group-directories-first";
      ll = "EZA_ICON_SPACING=2 eza -al --icons --group-directories-first";
      cd = "z";
    };
    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        DISABLE_MAGIC_FUNCTIONS=true
      '';
      plugins = [
        "git"
        "fzf"
        "cp"
        "dnf"
        "zoxide"
      ];
    };
    initContent = ''
      setopt nobeep autocd globdots extendedglob nomatch menucomplete interactive_comments
      bindkey '^H' backward-kill-word #CTRL+BACKSPACE
    '';
    plugins = [
      rec {
        name = "zsh-autosuggestions";
        src = pkgs.${name};
        file = "share/${name}/${name}.zsh";
      }
      rec {
        name = "nix-zsh-completions";
        src = pkgs.${name};
        file = "share/zsh/plugins/nix/${name}.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = inputs.fzf-tab;
      }
      {
        name = "conda-zsh-completion";
        src = inputs.conda-zsh-completion;
      }
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$container"
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$golang"
        "$haskell"
        "$helm"
        "$julia"
        "$kotlin"
        "$nim"
        "$ocaml"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];
      right_format = "$cmd_duration";
      username = {
        show_always = true;
        style_user = "bold blue";
        format = "[\\[](bold bright-blue)[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "  ";
        format = "[@](bold bright-blue)[$hostname]($style)[\\]](bold bright-blue)[$ssh_symbol](bright-blue) ";
        style = "bold blue";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      git_status = {
        style = "bold bright-red";
        format = "([\\[](bold purple)[$all_status$ahead_behind]($style)[\\]](bold purple) )";
      };
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
      line_break = {
        disabled = true;
      };
      container = {
        format = "[\\[$name\\]]($style) ";
        disabled = true;
      };
      python = {
        detect_extensions = [];
      };
    };
  };
  programs.direnv.enable = true;
}
