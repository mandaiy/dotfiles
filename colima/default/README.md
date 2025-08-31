# colima settings

## What changed

- cpu
  - increased to 8 (depends on your machine)
- disk
  - 120
- memory
  - increased to 16
- network.address
  - changed to true. This is needed to use
- network.network
  - added 1.1.1.1, 8.8.8.8 DNS entries
- vmType
  - `vz`
- rosetta:
  - `true`. rossetta is needed to be installed (`softwareupdate --install-rosetta`)
- mountType:
  - `virtiofs`. Much faster if using `vz`
- mountInotify
  - `true` for hot-reloading
