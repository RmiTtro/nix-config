{ lib
, buildPythonPackage
#, fetchPypi
, fetchFromGitHub
, pytestCheckHook
, pytest-cov
, setuptools
}:

buildPythonPackage rec {
  pname = "pipetools";
  version = "1.1.0";

  # The pypi package does not includes the tests
  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "8811d8871a1d555df93f3cd965edf7e8f3de96a4cecb88545664a063f7e5d220";
  #};
  
  # src from GitHub so the tests can be run
  src = fetchFromGitHub {
    owner = "0101";
    repo = pname;
    rev = "6cba9fadab07a16fd85eed16d5cffc609f84c62b";
    hash = "sha256-BoZFePQCQfz1dkct5p/WQLuXoNX3eLcnKf3Mf0fG6u8=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov # Might not be necessary
  ];

  propagatedBuildInputs = [
    setuptools
  ];
  
  # To disable the lauch of the tests
  # doCheck = false;
  
  pythonImportsCheck = [
    "pipetools"
  ];

  meta = with lib; {
    description = "A library that enables function composition similar to using Unix pipes";
    homepage = https://0101.github.io/pipetools/;
    license = licenses.mit;
    # maintainers = [ maintainers. ];
  };
}