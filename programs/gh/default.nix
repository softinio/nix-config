{ ... }:

{
  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        # Merged branches are dead weight; take them with the merge. GitHub's
        # own "automatically delete head branches" is a per-repo server-side
        # setting with no gh config key, so this is the part that can live here.
        prm = "pr merge --delete-branch";
      };
    };
  };

  programs.gh-dash = {
    enable = true;
  };
}
