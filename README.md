# What is this repo?

Just some personal notes on studying and tinkering with nix package manager.

# install nix

```bash
curl -L https://nixos.org/nix/install | sh
```

# activate nix develop
- add the line below to `.config/nix/nix.conf`

```
experimental-features = nix-command flakes
```

# start..
`nix develop`

# emacs local setup

- create .envrc 
- add `use flake`
- `direnv allow`
- install package https://github.com/purcell/envrc
- do `envrc-allow`  in emacs
- get buffers launching proceses with envvariables provided in your devshell


# flakes

# minimal flake

```nix
{
  description = "A simple script";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.my-script;

    packages.x86_64-darwin.my-script =
      let
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in
      pkgs.writeShellScriptBin "my-script" ''
        DATE="$(${pkgs.ddate}/bin/ddate +'the %e of %B%, %Y')"
        ${pkgs.cowsay}/bin/cowsay Hello, world! Today is $DATE.
      '';
  };
}
```

adding devshell
```nix
{
  description = "A simple script";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.my-script;

    packages.x86_64-darwin.my-script =
      let
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in
      pkgs.writeShellScriptBin "my-script" ''
        DATE="$(${pkgs.ddate}/bin/ddate +'the %e of %B%, %Y')"
        ${pkgs.cowsay}/bin/cowsay Hello, world! Today is $DATE.
          '';

      devShell.x86_64-darwin =
      let
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in pkgs.mkShell {
        buildInputs = with pkgs; [  ];
      };
  };
}
```

adding a dataset from github:

```nix
{
  description = "A simple script";

    inputs ={
        tennis-data = {
            url="github:JeffSackmann/tennis_atp";
            flake=false;
        };
    };
    
    outputs = { self, tennis-data, nixpkgs }: {
    defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.my-script;

    packages.x86_64-darwin.my-script =
      let
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in
      pkgs.writeShellScriptBin "my-script" ''
      cat ${tennis-data}/README.md
          '';

      devShell.x86_64-darwin =
      let
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in pkgs.mkShell {
        buildInputs = with pkgs; [  ];
      };
  };
}

```

# searching available nix packages

- `nix search yellowbrick`

# speeding things up

- Cachix: https://www.cachix.org/

## miscs

- `nix build github:Xe/gohello`
- `nix run github:Xe/gohello/main`

## References:
- Hermetic builds with Bob:  https://github.com/benchkram/bob
- https://christine.website/blog/nix-flakes-1-2022-02-21
- walkthrough poetry and nix develop https://www.youtube.com/watch?v=irPTtmP4xuM
- https://github.com/Xe/gohello/fork
- On nix store, graph and derivation concepts https://shopify.engineering/what-is-nix
- video on how shopify uses nix: https://engineering.shopify.com/blogs/engineering/shipit-presents-how-shopify-uses-nix
- reproduceable datasciene with nix https://josephsdavid.github.io/nix.html
