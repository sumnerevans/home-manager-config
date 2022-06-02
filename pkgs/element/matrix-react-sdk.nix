{ lib
, stdenv
, fetchpatch
, fetchFromGitHub
, fetchYarnDeps
, writeText
, jq
, yarn
, fixup_yarn_lock
, nodejs
}: stdenv.mkDerivation rec {
  pname = "matrix-react-sdk";
  version = "3.46.0-rc.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-react-sdk";
    rev = "v${version}";
    sha256 = "sha256-pdZDGqYZg6hEU2irVDj7f83rsMV2qQtcN7qtlR3eeEk=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-Zxz0/zDR1f+9KmvE9HxKqRrOdj6Rsu9ZD+Ii62ZvJT0=";
  };

  patches = [
    # All of my patches to matrix-react-sdk
    (fetchpatch {
      url = "https://github.com/sumnerevans/matrix-react-sdk/commit/ed00c00901c1741042162924bba5e800eee71402.patch";
      sha256 = "sha256-YNXRGlTDhYdIeciVRNkERqg366OYVgUaQWFAY9aP1p4=";
    })
  ];

  nativeBuildInputs = [ yarn fixup_yarn_lock jq nodejs ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$PWD/tmp
    mkdir -p $HOME

    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    node_modules/.bin/babel -d lib --verbose --extensions \".ts,.js,.tsx\" src
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -R . $out
    runHook postInstall
  '';
}
