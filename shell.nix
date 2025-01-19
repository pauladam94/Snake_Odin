{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    wayland
    odin
    ols
    wayland-protocols
    libxkbcommon
    glfw-wayland
    glfw
    clang
    bear
    openlibm
  ];

  BuildInputs = with pkgs; [
    wayland
    wayland-protocols
    libxkbcommon
    glfw-wayland
    glfw
  ];

  nativeBuildInputs = with pkgs; [
    libGL

    # ADD
    gcc
    odin
    # raylib
    glfw
    xorg.xeyes
    mesa
    libglvnd
    # ADD

    # X11 dependencies
    xorg.libX11
    xorg.libX11.dev
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    raylib
  ];
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    wayland
    glfw-wayland
    libxkbcommon
    libGL
    openlibm
  ]);
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXi}/lib:${pkgs.raylib}/lib:${pkgs.mesa}/lib:${pkgs.libglvnd}/lib:$LD_LIBRARY_PATH
    export LIBGL_ALWAYS_SOFTWARE=1
    export DISPLAY=:0
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=wayland
    export SDL_VIDEODRIVER=wayland
    echo "Odin environment running"
  '';
}
