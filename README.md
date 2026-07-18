# jbeam-edit-lsp

Language server for BeamNG JBeam files. It reuses the parser and formatter from
[jbeam-edit](https://github.com/webdevred/jbeam_edit) and exposes document
formatting over the Language Server Protocol.

## Relationship to jbeam-edit

The core parser and formatter live in the `jbeam-edit` repository, included here
as a git submodule under `external/jbeam-edit`. The submodule commit is the
pinned core version. Clone with submodules:

```sh
git clone --recursive https://github.com/webdevred/jbeam-edit-lsp.git
```

or, in an existing checkout:

```sh
git submodule update --init
```

To move to a newer core version:

```sh
git -C external/jbeam-edit checkout <ref>
git add external/jbeam-edit
```

## Build

```sh
cabal build exe:jbeam-lsp-server
```

## Test

```sh
cabal test
```
