# vault_pki_terraform

## Pre-requisites

* Install `certstrap`, `jq`, `vault` and `terraform`

## Launch

```
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

make
make generate

make 
```
