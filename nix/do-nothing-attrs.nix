{
  # No other phases
  dontPatch = true;
  dontConfigure = true;
  doCheck = false;
  dontBuild = true;
  dontFixup = true;
  doInstallCheck = false;
  # Zero out all patches
  patches = [];
  # Zero out all test dependencies
  checkInputs = [];
  # Zero out all build dependencies
  depsBuildBuild = [];
  nativeBuildInputs = [];
  depsBuildTarget = [];
  depsHostHost = [];
  buildInputs = [];
  depsTargetTarget = [];
  depsBuildBuildPropagated = [];
  propagatedNativeBuildInputs = [];
  depsBuildTargetPropagated = [];
  depsHostHostPropagated = [];
  propagatedBuildInputs = [];
  depsTargetTargetPropagated = [];
}
