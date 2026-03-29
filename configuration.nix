# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
     # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ./users.nix
    ./networking.nix
    ./boot.nix
    ./zram.nix
    ./impermanence.nix
  ];

  # After formatting with disko, the following is more robust for LUKS
  boot.initrd.luks.devices = {
     disk = {
       device = "/dev/disk/by-partlabel/luks";
       allowDiscards = true;
       preLVM = true;
     };
   };

  # This complements using zram, putting /tmp on RAM
    boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  # Enable autoScrub for btrfs
    services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  # Custom Options
  custom = {
    boot.enable = true;
    users.enable = true;
    zram.enable = true;
  };
 
  networking.hostName = "marol";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  hardware.usb-modeswitch.enable = true; 
  # networking.wireless.enable = true;
  # networking.wireless.userControlled.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the X11 windowing system.
  services.xserver = {
	enable = true;
	windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
     ];
    };
  };
  
  security.pam.services.i3lock.enable = true;
  services.displayManager.sddm.enable = true;

  programs.i3lock.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
	layout = "us,ru,ua";
	options = "grp:alt_shift_toggle";
  };

  # Last version that supports Kepler GPUs
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  # Enable sound.
  services.pipewire.enable = false;
  services.pulseaudio.enable = true;
  services.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  #Enable usb automounting
  services.gvfs.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marol = {
     isNormalUser = true;
     initialPassword = "catmeowingoutside";
     extraGroups = [ "networkmanager" "sudo" "wheel" "audio" "video" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
   };

  programs.firefox = {
  enable = true;
  package = pkgs.librewolf;
  policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    Preferences = {
      "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
      "cookiebanners.service.mode" = 2; # Block cookie banners
      "privacy.donottrackheader.enabled" = true;
      "privacy.fingerprintingProtection" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
    };
    ExtensionSettings = {
      "jid1-ZAdIEUB7XOzOJw@jetpack" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
};

environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
  
  # Install hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  # Install and Configure zsh
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
	"git"
    "z"
      ];
    }; 
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.extraUsers.marol.shell = pkgs.zsh;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
 
  nixpkgs.config = {
    allowUnfree = true;
  };
 programs.zoom-us.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
  anydesk
  arandr
  bat
  bleachbit
  curl
  dialog
  dosfstools
  doublecmd
  feh
  firefox
  flameshot
  font-awesome
  gimp-with-plugins
  git
  grim
  gruvbox-dark-gtk
  gruvbox-dark-icons-gtk
  gruvbox-material-gtk-theme
  gtop
  hunspell
  hunspellDicts.en_US
  hunspellDicts.ru_RU
  hunspellDicts.uk_UA
  jetbrains-mono
  killall
  kitty
  libreoffice-still
  lxappearance
  mako
  meslo-lgs-nf
  mousepad
  mtools
  networkmanagerapplet
  pavucontrol
  pcmanfm
  pdfstudio2024
  pfetch
  picom
  polkit_gnome
  polybar
  polybar-pulseaudio-control
  putty
  rofi
  rofi-power-menu
  sbctl
  siji
  slurp
  swaybg
  tealdeer
  telegram-desktop
  unifont
  usbutils
  viewnior
  vim
  vimPlugins.gruvbox
  vlc
  waybar
  wget
  whatsapp-electron
  xbacklight
  xclip
  xdg-desktop-portal-hyprland
  xdg-user-dirs
  xdg-utils
  yazi
  zathura
  zoom-us
  zsh-powerlevel10k
   ];
  
  nixpkgs.config.permittedInsecurePackages = [
    "electron" "olm-3.2.16"
	];

  # Flakes
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # font packages
   fonts.enableDefaultPackages = true;
   fonts.packages = with pkgs; [
   font-awesome_6
   jetbrains-mono
   nerd-fonts.jetbrains-mono
   siji 
   ];
  
  # List services that you want to enable:

  # Enable ssd triming.
  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Exclude some packages
  services.xserver.excludePackages = with pkgs; [
  xterm
];

  system.stateVersion = "26.05"; # Did you read the comment?

}
