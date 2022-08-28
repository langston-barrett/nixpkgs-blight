{ stdenv
, buildPythonPackage
, fetchPypi
, click
, pydantic
, typing-extensions
}:

let pname = "blight";
    version = "0.0.47";
in buildPythonPackage rec {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0rsnbkkpl10zaxdv835hd2jkqjqgvg6vz5avhl53mq4qvcd8hjpb";
  };
  buildInputs = [ ];
  propagatedBuildInputs = [ click pydantic typing-extensions ];
  meta = {};
}
