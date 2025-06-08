{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      in
      {
        devShells.default = pkgs.mkShell {

          buildInputs = with pkgs; [
            zsh
            nixfmt-rfc-style
            nil
            apple-sdk_15
            darwin.xcode_16_2
            swiftlint
          ];

          shellHook = ''
            # Your Xcode.app path - update this to match your actual path
            XCODE_PATH="/nix/store/i7m8av0nxj79z857bnjwcp0cvfry4bp5-Xcode.app"

            # Set up environment
            export DEVELOPER_DIR="$XCODE_PATH/Contents/Developer"
            export TOOLCHAINS=com.apple.dt.toolchain.XcodeDefault
            export XCODE_APP="$XCODE_PATH"

            # Swift toolchain paths
            SWIFT_TOOLCHAIN="$DEVELOPER_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin"

            # Add to PATH
            export PATH="$SWIFT_TOOLCHAIN:$DEVELOPER_DIR/usr/bin:$PATH"

            echo "🍎 Xcode Swift Environment Ready!"
            echo "================================="

            # Check if Xcode exists
            if [ -d "$XCODE_PATH" ]; then
              echo "✅ Xcode found at: $XCODE_PATH"
              
              # Check Swift
              if [ -f "$SWIFT_TOOLCHAIN/swift" ]; then
                echo "✅ Swift compiler available"
                echo "Swift version:"
                "$SWIFT_TOOLCHAIN/swift" --version | head -1
              else
                echo "❌ Swift not found at expected location"
              fi
            else
              echo "❌ Xcode not found at: $XCODE_PATH"
              echo "Please update XCODE_PATH in flake.nix"
            fi

            echo ""
            echo "🔧 Available tools:"
            echo "  swift, swiftc, xcodebuild, xcrun"
            echo ""
            echo "📍 Paths:"
            echo "  DEVELOPER_DIR: $DEVELOPER_DIR" 
            echo "  Swift toolchain: $SWIFT_TOOLCHAIN"
          '';
        };
      }
    );
}
