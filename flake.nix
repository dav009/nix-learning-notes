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
        buildInputs = with pkgs; [ go-tools  ];
      };
  };
}
