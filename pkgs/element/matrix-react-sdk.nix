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
  version = "3.44.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-react-sdk";
    rev = "v${version}";
    sha256 = "sha256-dvhXUO83JoygUQiaK5vkzfQm8qAc6BbhIbbyMxVONBg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-WMnlmT1iyNsOqowbc6+gqo4iZtEeDyPpG/8OV24aD7g=";
  };

  patches = [
    # All of my patches to matrix-react-sdk
    (fetchpatch {
      url = "https://github.com/sumnerevans/matrix-react-sdk/commit/70aeda0b6fd726587ff4c3c73c2039091685959d.patch";
      sha256 = "sha256-pcffwQ1Wur3+m0Ltj2NEMk/l85pMu8isiJknZW+5r3I=";
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
