{
  nemo = import ./nemo.nix;
  preferredApplications = import ./preferred-applications.nix;
  addCopyOnChange = import ./add-copy-on-change.nix;
}