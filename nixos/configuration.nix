# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grave"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # essentials
    wget
    vim
    sudo
    git

    binutils
    nix

    # X essentials
    rxvt_unicode
    dmenu

    # Xmonad
    haskellPackages.xmobar
    # haskellPackages.xmonad
    # haskellPackages.xmonad-contrib
    # haskellPackages.xmonad-extras
    haskellPackages.ghc
    haskellPackages.cabal-install

    # X fonts
    xfontsel
    xlsfonts

    # GUI software
    chromium
    firefoxWrapper
    xscreensaver
  ];

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    windowManager.default = "xmonad";
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    displayManager.slim = {
      enable = true;
      defaultUser = "dance";
      extraConfig = "/run/current-system/sw/bin/sessionstart_cmd xscreensaver -nosplash &";
    };
    libinput = {
      enable = true;
      # scrollButton = 2;
      additionalOptions = ''
                          Option "ScrollButton" "2"
			  Option "ScrollMethod" "button"
                          '';
      clickMethod = "clickfinger";
      tapping = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.dance = {
    description = "Hannu Hartikainen";
    isNormalUser = true;
    uid = 1000;
    home = "/home/dance";
    extraGroups = [ "wheel" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
# vim: et:sw=2:ts=2:ai
