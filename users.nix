{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    # Enabled with custom.users.enable = true; in `configuration.nix`
    custom.users.enable = lib.mkEnableOption "Enables users module";
  };

  config = lib.mkIf config.custom.users.enable {
    users.users = {
      marol = {
        homeMode = "755";
        isNormalUser = true;
        description = "marol75";
        # Change me! generate with `mkpasswd -m SHA-512 -s`
        # initialHashedPassword = "$6$knlskdQSQp4le3uiy..3$gAUAugTxAeHUpWKf6iwlkasdjf'lkajWNZRTtjbJ4X0PIjkIQOCcLcimOJe4Y0";

        extraGroups = [
          "networkmanager"
          "wheel"
          "root"
          "marol"
          "sudo"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        packages = [
          pkgs.tealdeer
          pkgs.zoxide
          pkgs.mcfly
          pkgs.tokei
          pkgs.stow
        ];
      };
    };
    # Best practice, enables `chown -R your-user:your-user`
    users.groups.marol = {};
  };
}
