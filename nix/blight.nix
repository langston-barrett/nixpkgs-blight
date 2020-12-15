{ stdenv
, buildPythonPackage
, fetchPypi
, click
, typing-extensions
}:

let pname = "blight";
    version = "0.0.18";
in buildPythonPackage rec {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0b6np4si3gs15s4qf2pyfg37r6avv4c6nqcrl664cbsaqr0xwizp";
  };
  buildInputs = [ ];
  propagatedBuildInputs = [ click typing-extensions ];
  meta = {};
}
