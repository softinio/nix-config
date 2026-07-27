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

  # Config for the reviewr plugin (github:persiyanov/herdr-reviewr).
  # herdr only creates this directory and exports it as $HERDR_PLUGIN_CONFIG_DIR;
  # the file itself is read solely by the plugin, so managing it here is safe.
  # The plugin install itself is still imperative (`herdr plugin install`).
  home.file.".config/herdr/plugins/config/persiyanov.reviewr/config.toml".text = ''
    theme = "tokyo-night"
    base_branches = ["main", "master"]
    default_scope = "branch"
    navigator_position = "right"
    toggle_placement = "split"
    toggle_direction = "right"
    auto_open = true
  '';
}
