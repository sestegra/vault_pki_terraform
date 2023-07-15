SHELL := /usr/bin/env bash

.PHONY: all rotate
all: \
	init \
	pki_int_v1.1 \
	pki_iss_v1.1.1 \
	roles \
	issuer_iss_v1.1.1

rotate: \
	init \
	pki_iss_v1.1.2

.PHONY: init
init:
	cd terraform \
		&& \
		terraform init

.PHONY: roles
roles:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_role.example_com

.PHONY: pki_int_v1.1
pki_int_v1.1: pki_int_v1.1.crt

pki_int_v1.1.csr:
	cd terraform \
		&& \
		terraform apply -auto-approve -target module.issuer_v1_1 \
		&& \
		terraform output -json > ../pki_int_v1.1.json
	jq -r .csr_v1_1.value pki_int_v1.1.json > pki_int_v1.1.csr

pki_int_v1.1.crt: pki_int_v1.1.csr
	certstrap --depot-path root sign \
    --CA "Example Labs Root CA v1" \
    --passphrase "secret" \
    --intermediate \
    --csr pki_int_v1.1.csr \
    --expires "5 years" \
    --path-length 1 \
    --cert pki_int_v1.1.crt \
    "Example Labs Intermediate CA v1.1"
	openssl x509 -in pki_int_v1.1.crt -text -noout
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_1 \
			-target vault_pki_secret_backend_config_issuers.int

.PHONY: pki_iss_v1.1.1
pki_iss_v1.1.1:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_1_1 \
		&& \
		terraform output -json > ../pki_iss_v1.1.1.json
	jq -r .certificate_v1_1_1.value pki_iss_v1.1.1.json > pki_iss_v1.1.1.crt
	jq -r .issuer_v1_1_1.value pki_iss_v1.1.1.json > pki_iss_v1.1.1.issuer
	openssl x509 -in pki_iss_v1.1.1.crt -text -noout

.PHONY: issuer_iss_v1.1.1
issuer_iss_v1.1.1: pki_iss_v1.1.1
	echo 'iss_default_issuer="$(shell cat pki_iss_v1.1.1.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve

.PHONY: pki_iss_v1.1.2
pki_iss_v1.1.2:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_1_2 \
		&& \
		terraform output -json > ../pki_iss_v1.1.2.json
	jq -r .certificate_v1_1_2.value pki_iss_v1.1.2.json > pki_iss_v1.1.2.crt
	jq -r .issuer_v1_1_2.value pki_iss_v1.1.2.json > pki_iss_v1.1.2.issuer
	openssl x509 -in pki_iss_v1.1.2.crt -text -noout

.PHONY: issuer_iss_v1.1.2
issuer_iss_v1.1.2: pki_iss_v1.1.2
	echo 'iss_default_issuer="$(shell cat pki_iss_v1.1.2.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve

.PHONY: issue_iss
issue_iss:
	VAULT_ADDR=http://127.0.0.1:8200 VAULT_TOKEN=root vault write -format=json \
    pki_iss/issue/example_com \
    common_name="sample.example.com" \
		ttl="5m" \
			| jq -r .data.certificate \
    	| openssl x509 -text -noout

.PHONY: clean
clean:
	killall -9 vault || true
	rm -f *.crt *.csr *.json
	rm -rf terraform/.terraform.lock.hcl terraform/.terraform
	rm -rf terraform/terraform.tfstate terraform/terraform.tfstate.backup
