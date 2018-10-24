PLANFILE ?= terraform.tfplan

init:
	@[ -d .terragrunt-cache ] || terragrunt init -no-color

plan: init
	chamber exec mailgun -- terragrunt $@ -out $(PLANFILE)

apply: init
	chamber exec mailgun -- terragrunt $@ -auto-approve=true $(PLANFILE)

destroy: init
	chamber exec mailgun -- terragrunt $@ -auto-approve=true

force-unlock: init
	terragrunt $@ -force $(LOCK_ID)

clean:
	rm -rf .terragrunt-cache
