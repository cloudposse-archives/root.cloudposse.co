PLANFILE ?= terraform.tfplan

init:
	@[ -d .terragrunt-cache ] || terragrunt init -no-color

plan:
	chamber exec mailgun -- terragrunt $@ -out $(PLANFILE)

apply:
	chamber exec mailgun -- terragrunt $@ -auto-approve=true $(PLANFILE)

destroy:
	chamber exec mailgun -- terragrunt $@ -auto-approve=true

force-unlock:
	terragrunt $@ -force $(LOCK_ID)

clean:
	rm -rf .terragrunt-cache
