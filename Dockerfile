FROM centos:7

MAINTAINER histrio <rinat.sabitov@gmail.com>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install openssh-server vim tmux zsh mosh openssh-clients \
    curl git htop openssh python2-pip net-tools iputils \
    telnet ack fzf man ctags wget gcc python2-devel && \
    ssh-keygen -A && usermod -s /usr/bin/zsh root && ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    ln -s --force /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    curl "https://www.dropbox.com/s/15rjnc0l7y0c487/.gitconfig?dl=1" > ~/.gitconfig && \
    curl "https://www.dropbox.com/s/utyh1m9q6hlqunu/.gitignore?dl=0" > ~/.gitignore && \
    git config --global user.email rsabitov@cloudlinux.com && git config --global user.name Rinat Sabitov && \
    curl "https://www.dropbox.com/s/c1rl3w5kna7qnmb/.vimrc?dl=1" > ~/.vimrc && \
    curl "https://www.dropbox.com/s/drep9vgdgfykq1w/.wakatime.cfg?dl=1" > ~/.wakatime.cfg && \
    git clone "https://github.com/VundleVim/Vundle.vim.git" ~/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall chdir=/tmp > /dev/null && \
    curl "https://www.dropbox.com/s/xwy9cs2vca0jrnu/.tmux.conf?dl=1" > ~/.tmux.conf && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts && \
    pip install git-review ansible virtualenv

COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

EXPOSE 22/tcp
EXPOSE 60000-61000/udp

ENTRYPOINT ["/usr/sbin/sshd", "-De"]
