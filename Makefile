.PHONY: all

all: init \
	pki_int_v1.1.crt \
	pki_int_v1.1.1.crt

.PHONY: init
init:
	cd terraform && \
		terraform init

pki_int_v1.1.csr:
	cd terraform && \
		terraform apply -auto-approve && \
		terraform output -json csr_v1_1 | jq -r . > ../pki_int_v1.1.csr

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

pki_int_v1.1.1.crt:
	cd terraform && \
		terraform apply -auto-approve && \
		terraform output -json certificate_v1_1_1 | jq -r . > ../pki_int_v1.1.1.crt
	openssl x509 -in pki_int_v1.1.1.crt -text -noout

.PHONY: clean
clean:
	killall -9 vault || true
	rm -f *.crt *.csr
	rm -rf terraform/.terraform.lock.hcl terraform/.terraform
	rm -rf terraform/terraform.tfstate terraform/terraform.tfstate.backup
