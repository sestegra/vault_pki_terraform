# vault_pki_terraform

## Pre-requisites

* Install `certstrap`, `jq`, `vault` and `terraform`

## Launch

```
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

# Build the CA
make init
make issuer_int_v1.1
make issuer_iss_v1.1.1
make roles

# Issue a certificate from the issuer v1.1.1
make issue_iss 

# Rotate the issuing CA
make issuer_iss_v1.1.2
# Issue a certificate from the issuer v1.1.2
make issue_iss

# Rotate the intermediate CA
make issuer_int_v1.2

# Rotate the issuing CA
make issuer_int_v1.2.1
# Issue a certificate from the issuer v1.2.1
make issue_iss

```

## Test the whole

```
make clean all && make issue_iss > example_v1.1.1.crt && \
make issuer_iss_v1.1.2 && make issue_iss > example_v1.1.2.crt && \
make issuer_int_v1.2 && make issuer_iss_v1.2.1 && make issue_iss > example_v1.2.1.crt && \
echo "Done"
```
