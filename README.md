# Peer Ban Helper Nix

Nix packages and NixOS modules of [Peer Ban Helper](https://github.com/PBH-BTN/PeerBanHelper)

## Usage

`flake.nix`:

```nix
{
  inputs = {
    # ...
    peer-ban-helper-nix = {
      url = "github:lialh4qwq/peer-ban-helper-nix";
      # Optional, but reduces the closure size.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ...
  };
  # ...
}
```

NixOS Modules:

```
{inputs, ...}: {
  # ...
  services.peer-ban-helper.enable = true;
  # ...
}
```

## License

This repository, including all Nix expressions, build scripts, modules, and other original code authored here, is licensed under the **MIT License**. See [LICENSE](./LICENSE) for the full text.

### Third-party package definitions

This repository contains Nix package definitions that build and package third-party software. **The license of this repository applies only to the packaging code itself (derivation expressions, patches, module options, etc.).** It does **not** extend to the software being packaged.

Each packaged program retains its own original license, as declared in its `meta.license` attribute. Notably, some packages build software licensed under the **GNU General Public License v3 (GPL-3.0)** or other copyleft licenses. Building or using this repository to produce binaries of GPL-3.0-licensed software means those resulting binaries are subject to the terms of GPL-3.0, independent of this repository's own MIT license.

If you redistribute binaries built from this repository, you are responsible for complying with the license terms of the underlying software being built.

#### Summary

```csv
Component,License
Nix expressions & packaging code (this repo),MIT
Packaged software,See each package's `meta.license`
```csv
