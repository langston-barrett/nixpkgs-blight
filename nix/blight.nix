{ stdenv
, buildPythonPackage
, fetchPypi
, click
, typing-extensions
}:

let pname = "blight";
    version = "0.0.20";
in buildPythonPackage rec {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0m0gng9iazwd3zivql76qlg6yr3269d1vcv48yjsxar4gai59aml";
  };
  buildInputs = [ ];
  propagatedBuildInputs = [ click typing-extensions ];
  meta = {};
}
