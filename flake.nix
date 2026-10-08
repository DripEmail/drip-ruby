{
  description = "Development environment for drip-ruby";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.actionlint
            pkgs.bash-completion
            pkgs.bashInteractive
            pkgs.bundler
            pkgs.curl
            pkgs.gh
            pkgs.git
            pkgs.jq
            pkgs.libyaml
            pkgs.pinact
            pkgs.pkg-config
            pkgs.ruby_3_3
            pkgs.shellcheck
            pkgs.zizmor
          ];

          shellHook = ''
            export GEM_HOME="$PWD/.bundle/gems"
            export BUNDLE_PATH="$GEM_HOME"
            export PATH="$GEM_HOME/bin:$PATH"
            echo "drip-ruby dev shell ($(ruby -v))"
            echo "Run 'bundle install' then 'bundle exec rake test' to get started."
          '';
        };
      });
}
