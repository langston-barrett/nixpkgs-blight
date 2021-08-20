{ stdenv
, buildPythonPackage
, fetchPypi
, click
, pydantic
, typing-extensions
}:

let pname = "blight";
    version = "0.0.33";
in buildPythonPackage rec {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1h52wwhqyml6zd5gckrq4cv83a4yjabvw5i60w5bbyibjsbh0d8s";
  };
  buildInputs = [ ];
  propagatedBuildInputs = [ click pydantic typing-extensions ];
  meta = {};
}
