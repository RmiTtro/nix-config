{
  nemo = import ./nemo.nix;
  preferredApplications = import ./preferred-applications.nix;
  permanenceHomeWrap = import ./permanence-home-wrap.nix;
  addCopyOnChange = import ./add-copy-on-change.nix;
}