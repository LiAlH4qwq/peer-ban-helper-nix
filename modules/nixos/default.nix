{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  options.services.peer-ban-helper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable Peer Ban Helper.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      # It results in a `no such attribution` error.
      # default = self.packages.${pkgs.stdenv.system}.peer-ban-helper-bin;
      default = pkgs.callPackage ../../packages/peer-ban-helper-bin { };
      defaultText = lib.literalMD "`self.packages.\${pkgs.stdenv.system}.peer-ban-helper-bin`";
      description = "Package of Peer Ban Helper";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/peer-ban-helper";
      description = "Data directory of Peer Ban Helper.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "peer-ban-helper";
      description = "User of Peer Ban Helper";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "peer-ban-helper";
      description = "Group of Peer Ban Helper";
    };
  };

  config =
    let
      cfg = config.services.peer-ban-helper;
    in
    lib.mkIf cfg.enable {
      systemd = {
        services.peer-ban-helper.serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${cfg.package}/bin/peer-ban-helper";
        };

        tmpfiles.settings.peer-ban-helper.${cfg.dataDir}.d = {
          user = "peer-ban-helper";
          group = "peer-ban-helper";
        };
      };

      users = {
        users.peer-ban-helper = {
          isSystemUser = true;
          group = "peer-ban-helper";
          home = "/var/lib/peer-ban-helper";
        };

        groups.peer-ban-helper = { };
      };
    };
}
