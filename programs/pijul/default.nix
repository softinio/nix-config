{ lib, user, ... }:

{
  # pijul config
  xdg.configFile."pijul/config.toml".text = lib.mkAfter ''
    [author]
    name = "${user.username}"
    full_name = "${user.fullName}"
    email = "${user.email}"
  '';
}
