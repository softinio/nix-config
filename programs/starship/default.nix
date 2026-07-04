{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 3000;
      character = {
        success_symbol = " [λ](bold green)";
        error_symbol = " [λ](bold red)";
      };

      # Custom darcs repository status
      custom.darcs = {
        description = "Display darcs repository status";
        command = "darcs whatsnew --summary 2>/dev/null | wc -l | tr -d ' '";
        when = "test -d _darcs";
        symbol = "⚖️  ";
        style = "bold purple";
        format = "[$symbol($output )]($style)";
      };
    };
  };
}
