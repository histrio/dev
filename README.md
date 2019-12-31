# devdocker

So, there is not so much. Just a dev environment for very me - python developer on vim.

    ansible-playbook site.yml -i <your-dev-server>, -e ansible_user=root
    mosh --ssh="ssh -i ~/.ssh/cl -p 8023" -- root@<your-dev-server> tmux new -A -s remote

