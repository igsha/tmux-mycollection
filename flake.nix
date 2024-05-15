{
  description = "A tmux plugin collection";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: let
    overlay = final: prev: {
      tmuxPlugins = prev.tmuxPlugins // {
        mycollection = prev.tmuxPlugins.mkTmuxPlugin {
          pluginName = "mycollection";
          version = "unstable-2024-05-15";
          src = ./.;
        };
      };
    };
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ overlay ];
    };
  in {
    overlays.default = overlay;
    packages.x86_64-linux = {
      tmuxPlugins.mycollection = pkgs.tmuxPlugins.mycollection;
      default = self.packages.x86_64-linux.tmuxPlugins.mycollection;
    };
  };
}
