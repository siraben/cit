let
  nixpkgs = import ./pinned_nixpkgs.nix;
  pkgs = import nixpkgs { };
  tools = import ./tools.nix { pkgs = pkgs; };
  nonRootShadowSetup = import ./docker_shadow_setup.nix { pkgs = pkgs; };
in
rec {
  world = pkgs.dockerTools.buildImage rec {
    name = "melg8/cit";
    tag = "0.0.6";
    contents = tools
      ++ nonRootShadowSetup { uid = 1000; user = "user"; };
    config = {
      Cmd = [ "sh" ];
      User = "user";
      WorkingDir = "/home/user/work";
      Env = [
        "NODE_PATH=/usr/lib/node_modules"
        "NIX_PAGER=cat"
        "USER=user"
        "NIX_PATH=nixpkgs=${pkgs.path}"
      ];
    };
    extraCommands = import ./docker_extra_commands.nix { inherit contents; };
  };
}
