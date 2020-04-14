.PHONY: ssh, deploy, pub, build

build:
	docker build -t histrio/devdocker:latest .

pub:
	docker push histrio/devdocker:latest

ssh:
	mosh --ssh="ssh -i ~/.ssh/cl -p 8023" -- histrio@$(DEVSERVER) tmux new -A -s remote

deploy:
	ansible-galaxy role install geerlingguy.repo-epel geerlingguy.pip geerlingguy.docker
	ansible-playbook site.yml -i $(DEVSERVER), -e ansible_user=root
