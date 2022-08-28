{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "nasm";
  version = "2.15.04rc3";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${pname}-${version}.tar.xz";
    sha256 = "1hf4s7j9hb0aknnhz8pmar0k7hsk0g880zd7vxhjxq2l8xqjm0ph";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    make golden
    make test
  '';

  meta = with lib; {
    homepage = "https://www.nasm.us/";
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
    license = licenses.bsd2;
  };
}
