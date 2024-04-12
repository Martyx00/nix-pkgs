{ 
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
}:
with import <nixpkgs> {};
with pkgs.makeDesktopItem;
let 
  icon_file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/eclipse-theia/theia/master/logo/theia.svg";
    sha256 = "sha256-2XEuO3mpjXsdX9ZNcJ2qgGvmlEw/DOvyKHnNDjwIzgY=";
  };
in
  appimageTools.wrapType2 {
    name = "theia";
    version = "1.48.300";
    src = pkgs.fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?file=/theia/ide/latest/linux/TheiaIDE.AppImage&r=1";
      sha256 = "sha256-Aw/Vv0wuJ4rmpOCPcbr9cABvfNANAD3IRYVGsZiWjdw=";
    };
    /* Desktop file and meta configuration go here */
   extraInstallCommands = ''
    mkdir -p $out/share/applications
    echo "[Desktop Entry]
    Type=Application
    Name=Theia IDA
    Exec=$out/bin/theia
    Terminal=false
    Icon=${icon_file}" > $out/share/applications/theia.desktop
  '';
  
}
