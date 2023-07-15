# vault_pki_terraform

## Pre-requisites

* Install `certstrap`, `jq`, `vault` and `terraform`

## Launch

```
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

terraform init
terraform apply -auto-approve -target=module.issuer_v1_1
```
