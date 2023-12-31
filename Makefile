SHELL := /usr/bin/env bash

.PHONY: all rotate
all: \
	issuer_root_v1 \
	init \
	issuer_int_v1.1 \
	issuer_iss_v1.1.1 \
	roles

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

.PHONY: issue_iss
issue_iss:
	VAULT_ADDR=http://127.0.0.1:8200 VAULT_TOKEN=root vault write -format=json \
    pki_iss/issue/example_com \
    common_name="sample.example.com" \
		ttl="5m" \
			| jq -r .data.certificate \
    	| openssl x509 -text -noout

# v1
.PHONY: issuer_root_v1
root/Example_Labs_Root_CA_v1.crt:
	certstrap --depot-path root init \
		--organization "Example" \
		--common-name "Example Labs Root CA v1" \
		--expires "10 years" \
		--curve P-256 \
		--path-length 2 \
		--passphrase "secret"

issuer_root_v1: root/Example_Labs_Root_CA_v1.crt

# v2
.PHONY: issuer_root_v2
root/Example_Labs_Root_CA_v2.crt:
	certstrap --depot-path root init \
		--organization "Example" \
		--common-name "Example Labs Root CA v2" \
		--expires "10 years" \
		--curve P-256 \
		--path-length 2 \
		--passphrase "secret"

issuer_root_v2: root/Example_Labs_Root_CA_v2.crt

# v1.1
.PHONY: issuer_int_v1.1
issuer_int_v1.1: pki_int_v1.1.crt
	echo 'int_default_issuer="$(shell cat pki_int_v1.1.issuer)"' > terraform/pki_int.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.int

pki_int_v1.1.csr:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_1 \
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
		&& \
		terraform output -json > ../pki_int_v1.1.json
	jq -r .issuer_v1_1.value pki_int_v1.1.json > pki_int_v1.1.issuer

# v1.2
.PHONY: issuer_int_v1.2
issuer_int_v1.2: pki_int_v1.2.crt
	echo 'int_default_issuer="$(shell cat pki_int_v1.2.issuer)"' > terraform/pki_int.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.int

pki_int_v1.2.csr:
	cd terraform \
		&& \
		terraform apply -auto-approve -target module.issuer_v1_2 \
		&& \
		terraform output -json > ../pki_int_v1.2.json
	jq -r .csr_v1_2.value pki_int_v1.2.json > pki_int_v1.2.csr

pki_int_v1.2.crt: pki_int_v1.2.csr
	certstrap --depot-path root sign \
		--CA "Example Labs Root CA v1" \
		--passphrase "secret" \
		--intermediate \
		--csr pki_int_v1.2.csr \
		--expires "5 years" \
		--path-length 1 \
		--cert pki_int_v1.2.crt \
		"Example Labs Intermediate CA v1.2"
	openssl x509 -in pki_int_v1.2.crt -text -noout
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_2 \
		&& \
		terraform output -json > ../pki_int_v1.2.json
	jq -r .issuer_v1_2.value pki_int_v1.2.json > pki_int_v1.2.issuer

# v2.1
.PHONY: issuer_int_v2.1
issuer_int_v2.1: pki_int_v2.1.crt
	echo 'int_default_issuer="$(shell cat pki_int_v2.1.issuer)"' > terraform/pki_int.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.int

pki_int_v2.1.csr:
	cd terraform \
		&& \
		terraform apply -auto-approve -target module.issuer_v2_1 \
		&& \
		terraform output -json > ../pki_int_v2.1.json
	jq -r .csr_v2_1.value pki_int_v2.1.json > pki_int_v2.1.csr

pki_int_v2.1.crt: pki_int_v2.1.csr
	certstrap --depot-path root sign \
		--CA "Example Labs Root CA v2" \
		--passphrase "secret" \
		--intermediate \
		--csr pki_int_v2.1.csr \
		--expires "5 years" \
		--path-length 1 \
		--cert pki_int_v2.1.crt \
		"Example Labs Intermediate CA v2.1"
	openssl x509 -in pki_int_v2.1.crt -text -noout
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v2_1 \
		&& \
		terraform output -json > ../pki_int_v2.1.json
	jq -r .issuer_v2_1.value pki_int_v2.1.json > pki_int_v2.1.issuer

# v1.1.1
.PHONY: pki_iss_v1.1.1 issuer_iss_v1.1.1
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

issuer_iss_v1.1.1: pki_iss_v1.1.1
	echo 'iss_default_issuer="$(shell cat pki_iss_v1.1.1.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.iss

# v1.1.2
.PHONY: pki_iss_v1.1.2 issuer_iss_v1.1.2
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

issuer_iss_v1.1.2: pki_iss_v1.1.2
	echo 'iss_default_issuer="$(shell cat pki_iss_v1.1.2.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.iss

# v1.2.1
.PHONY: pki_iss_v1.2.1 issuer_iss_v1.2.1
pki_iss_v1.2.1:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v1_2_1 \
		&& \
		terraform output -json > ../pki_iss_v1.2.1.json
	jq -r .certificate_v1_2_1.value pki_iss_v1.2.1.json > pki_iss_v1.2.1.crt
	jq -r .issuer_v1_2_1.value pki_iss_v1.2.1.json > pki_iss_v1.2.1.issuer
	openssl x509 -in pki_iss_v1.2.1.crt -text -noout

issuer_iss_v1.2.1: pki_iss_v1.2.1
	echo 'iss_default_issuer="$(shell cat pki_iss_v1.2.1.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.iss

# v2.1.1
.PHONY: pki_iss_v2.1.1 issuer_iss_v2.1.1
pki_iss_v2.1.1:
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target module.issuer_v2_1_1 \
		&& \
		terraform output -json > ../pki_iss_v2.1.1.json
	jq -r .certificate_v2_1_1.value pki_iss_v2.1.1.json > pki_iss_v2.1.1.crt
	jq -r .issuer_v2_1_1.value pki_iss_v2.1.1.json > pki_iss_v2.1.1.issuer
	openssl x509 -in pki_iss_v2.1.1.crt -text -noout

issuer_iss_v2.1.1: pki_iss_v2.1.1
	echo 'iss_default_issuer="$(shell cat pki_iss_v2.1.1.issuer)"' > terraform/pki_iss.auto.tfvars
	cd terraform \
		&& \
		terraform apply -auto-approve \
			-target vault_pki_secret_backend_config_issuers.iss

.PHONY: clean clean_root
clean:
	killall -9 vault || true
	rm -f *.crt *.csr *.json
	rm -rf terraform/.terraform.lock.hcl terraform/.terraform
	rm -rf terraform/terraform.tfstate terraform/terraform.tfstate.backup

clean_root:
	rm -rf root
