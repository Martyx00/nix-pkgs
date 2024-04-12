{
    pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
}:
with import <nixpkgs> {};
with pkgs.python3Packages;
with pkgs.makeDesktopItem;
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
buildPythonPackage rec {
    pname = "collare";
    version = "1.4";
    propagatedBuildInputs = [
        qt5.qtwayland
        (pkgs.python3.withPackages(ps: with ps; [
            requests
            pyqt5
        ]))
    ];

    dontUseSetuptoolsCheck = true;
    src = fetchFromGitHub {
        owner = "Martyx00";
        repo = "CollaRE";
        rev = "v1.4";
        sha256 = "sha256-6W+1bba0p4+I5cOHsTDDW6wnOdSJz7mmQoRk2r8DnVk=";
    };

    dontWrapQtApps = true;

    nativeBuildInputs = with pkgs; [
      copyDesktopItems
    ];

    icon_file = pkgs.fetchurl {
      url = "https://github.com/Martyx00/CollaRE/blob/master/collare/icons/collare.png?raw=true";
      sha256 = "sha256-m/pwz1fi0YgDU8Z/6X2wsmV3+8OWqaGPRG8YIdafKzs=";
    };
    desktopItems  = [
        ( makeDesktopItem {
            name = "collare";
            exec = "bash -c \"export QT_QPA_PLATFORM=wayland; collare\"";
            icon = icon_file;
            comment = "CollaRE for erversing collaboration";
            desktopName = "CollaRE";
            genericName = "Collaborative Reverese Engineeing";
            categories = [ "Development" ];
        })
    ];


    meta = with lib; {
        description = "CollaRE packaged for NIX";
        homepage = "https://github.com/Martyx00/CollaRE";
        license = licenses.asl20;
        maintainers = with maintainers; [ Martyx00 ];
        platforms = [ "x86_64-linux" ];
        mainProgram = "collare";
    };
}
