{ stdenv
, buildPythonPackage
, fetchPypi
, click
, pydantic
, typing-extensions
}:

let pname = "blight";
    version = "0.0.29";
in buildPythonPackage rec {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0sg5z3m83nqhp7p0x1qmnzi3p48vynlrx0slz4pdfbbvawpw7s4w";
  };
  buildInputs = [ ];
  propagatedBuildInputs = [ click pydantic typing-extensions ];
  meta = {};
}
