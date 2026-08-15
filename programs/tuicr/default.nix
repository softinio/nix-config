{ pkgs, user, ... }:
{
  # tuicr complements the reviewr herdr plugin rather than replacing it. reviewr owns the
  # inner loop (its `t` scope shows only what the agent changed last turn, and `s` pushes
  # comments straight into the agent's input). tuicr covers the two things reviewr will not
  # do by design:
  #
  #   tuicr pr <N>                  review a PR and `:submit` real inline comments via gh
  #   tuicr -r <base>...HEAD        the exact stacked diff against a base branch that is
  #                                 not main — reviewr's base pick is per repo, so it
  #                                 cannot differ between two worktrees of the same repo
  #
  # It is also the jj-native reviewer of the two.
  home.packages = [ pkgs.tuicr ];

  home.file.".config/tuicr/config.toml".text = ''
    theme = "tokyo-night-storm"
    diff_view = "side-by-side"
    username = "${user.fullName}"
  '';
}
