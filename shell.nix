{ pkgs ? import <nixpkgs> {} }:
  
with pkgs;

let
  inherit (lib) optional optionals;

  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  erlang = beam.interpreters.erlangR23;
  elixir = beam.packages.erlangR23.elixir_1_11;
  podman = pkgs.podman;
  nodejs = nodejs-14_x;
in

mkShell {
  LOCALE_ARCHIVE_2_27 = "${glibcLocales}/lib/locale/locale-archive";

  buildInputs = [cacert git erlang elixir podman nodejs slirp4netns python38]
    ++ optional stdenv.isLinux libnotify
    ++ optional stdenv.isLinux inotify-tools;

  shellHook = ''
  echo "=========> Checking if db container already exists"
  if [[ $(podman ps -a | grep db) ]]; then
    echo "---------> Yes. Starting container..."
    podman start db
  else
    echo "=========> Migrating podman"
    podman system migrate
    echo "---------> No. Creating container..."
    podman run --name db -p 5432:5432 -d \
      -e POSTGRES_PASSWORD=postgres \
      -e POSTGRES_USER=postgres \
      --signature-policy ./container/policy.json \
      docker.io/postgres:13-alpine

    echo -e "\nAlmost there. The following steps are missing:"
    echo -e "\n    $ mix setup"

    echo -e "\nStart Snippets with:"
    echo -e "\n    $ mix phx.server"
  fi

  echo -e "\n=========> Done!"
  '';
}