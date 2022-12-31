.PHONY: ssh, deploy, pub, build

ssh:
	mosh -- histrio@$(DEVSERVER) tmux new -A -s remote

deploy:
	ansible-playbook bootstrap.yml -i $(DEVSERVER), -e ansible_user=root

force-deploy:
	ansible-playbook local.yml -i $(DEVSERVER), -e ansible_user=histrio
