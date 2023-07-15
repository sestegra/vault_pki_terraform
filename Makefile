.PHONY: all

all: terraform/.terraform.lock.hcl \
	pki_int_v1.1.crt

terraform/.terraform.lock.hcl:
	cd terraform && \
		terraform init

pki_int_v1.1.csr:
	cd terraform && \
		terraform apply -auto-approve && \
		terraform output -json csr_v1_1 | jq -r .csr > ../pki_int_v1.1.csr

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
	cd terraform && \
		terraform apply -auto-approve

.PHONY: clean
clean:
	killall -9 vault || true
	rm -f *.crt *.csr
	rm -rf terraform/.terraform.lock.hcl terraform/.terraform
	rm -rf terraform/terraform.tfstate terraform/terraform.tfstate.backup
