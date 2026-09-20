{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = config.home.homeDirectory;
  logFile = "${home}/Library/Logs/worktree-audit.log";

  # Installed verbatim (not via writeShellApplication) because --help prints the
  # script's own header comment via `awk` on "$0", and the script relies on
  # errexit being off.
  worktreeAudit =
    pkgs.runCommand "worktree-audit"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ pkgs.bash ];
      }
      ''
        install -Dm755 ${./worktree-audit.sh} $out/bin/worktree-audit
        patchShebangs $out/bin/worktree-audit
        # git comes from nixpkgs; nix, du, find and sort come from the system so
        # nix matches the daemon version and the script also works under launchd
        wrapProgram $out/bin/worktree-audit \
          --prefix PATH : ${lib.makeBinPath [ pkgs.git ]} \
          --suffix PATH : /run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin
      '';
in
{
  home.packages = [ worktreeAudit ];

  # Clears caches in linked worktrees only. Main checkouts are skipped so their
  # build output and dev shells survive, and build/dist are excluded because
  # some repos track them. Never removes worktrees (no --cleanup).
  #
  # First of the three Saturday disk-space jobs, ahead of nix.gc at 08:00 and
  # nix.optimise at 09:00 (both in flake.nix): this deletes the .direnv symlinks
  # that pin store paths, so the GC an hour later can actually collect them.
  # launchd reads the interval in local time, which is Pacific on this machine.
  launchd.agents.worktree-audit = {
    enable = true;
    config = {
      ProgramArguments = [
        "${worktreeAudit}/bin/worktree-audit"
        "--clean-caches"
        "--skip-main"
        "--cache-dirs"
        "node_modules,target,.venv,.direnv"
        "--yes"
        "${home}/Projects"
        "${home}/OpenSource"
        "${home}/Learn"
      ];
      StartCalendarInterval = [
        {
          Weekday = 6; # Saturday
          Hour = 7;
          Minute = 0;
        }
      ];
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
      ProcessType = "Background";
    };
  };
}
