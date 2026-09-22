{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = config.home.homeDirectory;
  logFile = "${home}/Library/Logs/cache-sweep.log";

  # Installed verbatim (not via writeShellApplication) for the same reasons as
  # worktree-audit: --help prints the script's own header via `awk` on "$0",
  # and the script relies on errexit being off.
  cacheSweep =
    pkgs.runCommand "cache-sweep"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ pkgs.bash ];
      }
      ''
        install -Dm755 ${./cache-sweep.sh} $out/bin/cache-sweep
        patchShebangs $out/bin/cache-sweep
        # git comes from nixpkgs (it decides what is safe to delete, via
        # check-ignore); du, find and df come from the system so the script
        # also works under launchd
        wrapProgram $out/bin/cache-sweep \
          --prefix PATH : ${lib.makeBinPath [ pkgs.git ]} \
          --suffix PATH : /run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin
      '';
in
{
  home.packages = [ cacheSweep ];

  # Second of the three Saturday disk-space jobs: worktree-audit clears caches
  # in linked worktrees at 07:00, this prunes the home-directory caches and
  # stale build output at 07:30, and nix.gc collects the freed store paths at
  # 08:00 (flake.nix). Nothing here creates or removes GC roots, so it only
  # needs to land before the GC, not in a particular order against the audit.
  #
  # 30 days is deliberately conservative: a cache entry has to go a month
  # untouched before it is considered dead.
  launchd.agents.cache-sweep = {
    enable = true;
    config = {
      ProgramArguments = [
        "${cacheSweep}/bin/cache-sweep"
        "--age"
        "30"
        "--yes"
        "${home}/Projects"
        "${home}/OpenSource"
        "${home}/Learn"
      ];
      StartCalendarInterval = [
        {
          Weekday = 6; # Saturday
          Hour = 7;
          Minute = 30;
        }
      ];
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
      ProcessType = "Background";
    };
  };
}
