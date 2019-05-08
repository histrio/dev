FROM centos:7

MAINTAINER histrio <rinat.sabitov@gmail.com>

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install openssh-server vim tmux zsh mosh openssh-clients \
                   curl git htop openssh python2-pip net-tools iputils\
                   telnet ack fzf man ctags wget

USER root
RUN ssh-keygen -A && usermod -s /usr/bin/zsh root
RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV TERM=xterm-256color LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN ln -s --force /usr/share/zoneinfo/Europe/Moscow /etc/localtime

RUN git config --global user.email rsabitov@cloudlinux.com && git config --global user.name Rinat Sabitov
RUN wget "https://www.dropbox.com/s/15rjnc0l7y0c487/.gitconfig?dl=1" -O ~/.gitconfig

COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

RUN wget "https://www.dropbox.com/s/c1rl3w5kna7qnmb/.vimrc?dl=1" -O ~/.vimrc && \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall chdir=/tmp 700fcc04-759d-4573-9c74-52d0464f4df7 > /dev/null

#Oh my zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Powerline fonts
RUN git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts

#RUN rpm -Uvh --nodeps $(repoquery --location rxvt-unicode)

RUN pip install git-review ansible virtualenv

EXPOSE 22/tcp
EXPOSE 60000-61000/udp

ENTRYPOINT ["/usr/sbin/sshd", "-De"]
