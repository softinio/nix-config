{ pkgs, ... }:

let
  aiderConfig = builtins.readFile ./aider.yml;
in
{
  home.packages = with pkgs; [
    aider-chat
    streamlit
    python3Packages.greenlet
    python3Packages.llama-index-core
    python3Packages.llama-index-embeddings-huggingface
    python3Packages.playwright
    python3Packages.watchdog
  ];
  home.file.".aider.conf.yml".text = aiderConfig;
}
