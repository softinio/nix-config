{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # uv: activate the project's own venv managed by uv
      layout_uv() {
        if [[ -d .venv ]]; then
          VIRTUAL_ENV="$(pwd)/.venv"
        else
          uv venv .venv
          VIRTUAL_ENV="$(pwd)/.venv"
        fi
        export VIRTUAL_ENV
        PATH_add "$VIRTUAL_ENV/bin"
        export UV_ACTIVE=1
      }

      # poetry: activate the poetry-managed venv for the project
      layout_poetry() {
        local venv
        venv=$(poetry env info --path 2>/dev/null)
        if [[ -z $venv ]]; then
          poetry install --no-root
          venv=$(poetry env info --path)
        fi
        export VIRTUAL_ENV="$venv"
        PATH_add "$venv/bin"
      }
    '';
  };
}
