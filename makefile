.PHONY: ssh, deploy, pub, build

build:
	docker build -t histrio/devdocker:latest .

pub:
	docker push histrio/devdocker:latest

ssh:
	mosh --ssh="ssh -i ~/.ssh/cl" -- histrio@$(DEVSERVER) tmux new -A -s remote

deploy:
	ansible-playbook bootstrap.yml -i $(DEVSERVER), -e ansible_user=root
