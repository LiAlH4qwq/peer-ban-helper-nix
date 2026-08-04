{ lib, pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "peer-ban-helper";
  version = "9.4.2";

  src = pkgs.fetchzip {
    url = "https://github.com/PBH-BTN/PeerBanHelper/releases/download/v9.4.2/PeerBanHelper_9.4.2.zip";
    hash = "sha256-b/Uz/NIVyIZmwDMc29AUOu6OqkoS0wu8sRJscZAjWpw=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${finalAttrs.pname}

    cp -rt $out/share/${finalAttrs.pname}/ ./libraries
    cp -t $out/share/${finalAttrs.pname}/ ./PeerBanHelper.jar

    makeWrapper ${pkgs.javaPackages.compiler.temurin-bin.jdk-25}/bin/java $out/bin/${finalAttrs.pname} \
      --add-flags "-cp \"$out/share/${finalAttrs.pname}/libraries/*:$out/share/${finalAttrs.pname}/PeerBanHelper.jar\"" \
      --add-flags "com.ghostchu.peerbanhelper.MainJumpLoader"

    runHook postInstall
  '';

  meta = {
    description = "Automatically block unwanted, leeches and abnormal BT peers with support for customized and cloud rules.";
    homepage = "https://github.com/PBH-BTN/PeerBanHelper";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
