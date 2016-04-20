# my configuration.nix for Thinkpad X220i

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader. (disable legacy BIOS emulation!)
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grave";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  environment.systemPackages = with pkgs; [
    # essentials
    wget
    vim
    sudo
    git

    binutils
    nix
    acpi
    usbutils

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
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.dance = {
    description = "Hannu Hartikainen";
    isNormalUser = true;
    uid = 1000;
    home = "/home/dance";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";


  ### Thinkpad X220i specific

  # TPM has hardware RNG
  security.rngd.enable = true;

  # TLP Linux Advanced Power Management
  services.tlp.enable = true;

  # hard disk protection if the laptop falls
  services.hdapsd.enable = true;

  # trackpoint support (touchpad disabled in this config)
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # alternatively, touchpad with two-finger scrolling
  #services.xserver.libinput.enable = true;

  # fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;
  # similarly for other PAM providers
}
# vim: et:sw=2:ts=2:ai