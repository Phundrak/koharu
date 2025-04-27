{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    at-spi2-atk
    atkmm
    cairo
    cargo-tauri
    gdk-pixbuf
    glib
    gobject-introspection
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    libuuid
    openssl
    pango
    pkg-config
    pkg-config
    webkitgtk_4_1
    xdg-utils
  ];

  # https://devenv.sh/languages/
  languages.rust = {
    enable = true;
    channel = "nightly";
  };

  # https://devenv.sh/processes/
  processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/scripts/
  scripts = {
    build.exec = ''
      ${pkgs.bun}/bin/bun tauri build
    '';
    dev.exec = ''
      ${pkgs.bun}/bin/bun tauri dev
    '';
  };

  enterShell = ''
    echo
    echo Bun version: ''$(${pkgs.bun}/bin/bun --version)
    echo Cargo version: ''$(cargo --version)
    echo Rust version: ''$(rustc --version)
    echo
  '';

  env.LD_LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.libuuid ]}:$LD_LIBRARY_PATH";

  # https://devenv.sh/tasks/
  tasks = {
    "koharu:setup".exec = ''
      ${pkgs.bun}/bin/bun install
      if [ ! -e ".env" ]; then
        cp .env.example .env
      fi
    '';
    "devenv:enterShell".after = [ "koharu:setup" ];
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    cargo test
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    clippy = {
      enable = true;
      settings.allFeatures = true;
    };
    eslint.enable = true;
    markdownlint.enable = true;
  };

  dotenv.enable = true;
}
