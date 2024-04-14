# Kotlin experiments in Nix
{pkgs, ...} :
{
  packages = with pkgs; [
                kotlin
                kotlin-native
                kotlin-language-server
              ];
}