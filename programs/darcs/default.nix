{ user, ... }:

{
  programs.darcs = {
    enable = true;
    author = [ "${user.fullName} <${user.email}>" ];
    boring = [
      "^.idea$"
      "^.direnv$"
      "^.envrc$"
      "^.vscode$"
      "^.gitignore$"
    ];
  };

  # darcs defaults
  home.file.".darcs/defaults".text = ''
    diff diff-command colordiff -rN -u %1 %2
  '';
}
