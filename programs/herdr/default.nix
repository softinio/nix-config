{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "tokyo-night"

    [theme.custom]
    accent = "orange"

    [ui]
    show_agent_labels_on_pane_borders = true
    accent = "orange"

    [ui.sound]
    enabled = false

    [ui.toast]
    delivery = "herdr"

    [keys]
    split_vertical = "prefix+'"
    split_horizontal = "prefix+minus"
  '';
}
