# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:
{



  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

environment.pathsToLink = ["/libexec"]; 

  programs.zsh.enable = true;
  programs.zsh.promptInit = "";
  programs.ssh.startAgent = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      dmenu
      alacritty
      xwayland
      docker
      python3
#     telegram-purple
      slurp #screenshots in wayland
      wev # used find keyboards symbol names
      gnumake # for vterm compiling 
      cmake # for vterm compiling
      libtool # for vterm compiling
      gcc
      thunderbird
    ];
  };

environment = {
etc = {
"sway/config".source = ./dotfiles/sway/config;


};
};

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "sway";
    xkbOptions = "ctrl:swapcaps";
    libinput.enable = true;
    layout = "us";
    xkbVariant = "dvorak";
  };

#nix.trustedUsers = ́̂́́́̂́́́́́̌[̂̂̂"root", "dave"];

  users = {
    users.dave = {
      shell = pkgs.zsh;
      isNormalUser = true;
      home = "/home/dave";
      description = "David H";
      extraGroups = [ "audio" "docker" ];
      #extraGroups = [ "audio" "wheel" "networkmanager" "vboxusers" "docker" ];
    };
  };
# services.xserver.enable = true;
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome3.enable = true;

# #services.xserver.displayManager.defaultSession = "none+i3";
#
#services.xserver = {
#	enable = true;
#
#	desktopManager = {
#	xterm.enable = false;
#};
#
##	displayManager.defaultSession = "none+i3";
#	displayManager.session = [
#{
#	manage = "desktop";
#	name = "none+i3";
#        start = ''exec $HOME/.xsession'';
#}
#
#		];
#};
#



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
 time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
console = {
useXkbConfig = true;
     font = "Lat2-Terminus16";
#     keyMap = "dvorak";
   };

# Configure keymap in X11  
#  console.keyMap = "dvorak" 
# services.xserver.xkbOptions = "eurosign:e"; 
# # Enable CUPS to print documents.  
# # services.printing.enable = true; 
# # Enable sound.  
sound.enable = true; 
hardware.pulseaudio.enable = true; 
# # Enable touchpad support (enabled default in most desktopManager).  
# # services.xserver.libinput.enable = true; 
# 
# 
# # Define a user account. Don't forget to set a password with ‘passwd’.  
# Enable ‘sudo’ for the user.  
# # List packages installed in system profile. To search, run: # 
# $ 
# nix search wget 
environment.systemPackages = with pkgs; [ wget 
				       	vim 
					firefox 
					zsh 
					skype 
					git 
					discord 
					emacs 
					ripgrep 
					fd 
					dropbox-cli 
((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]))
];
 networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

# execute to sync
# dropbox status
# dropbox start
# dropbox autostart y
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };
# Some programs need SUID wrappers, can be configured further or are # started in user sessions.  # programs.mtr.enable = true; # programs.gnupg.agent = { #   enable = true; 
# #   enableSSHSupport = true; # }; # List services that you want to enable:

nixpkgs.config.allowUnfree = true;

 # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?


}

