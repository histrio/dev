FROM centos:7

LABEL MAINTAINER="histrio <rinat.sabitov@gmail.com>"
ARG USER=histrio

COPY requirements.txt bootstrap.sh /tmp/
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install $(cat /tmp/requirements.txt) && \
    pip install git-review ansible virtualenv && \
    useradd ${USER} -G wheel && \
    usermod -s /usr/bin/zsh ${USER} && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    ln -s --force /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    ssh-keygen -A

    # git clone https://gist.github.com/56d80c4f2f560953515014d3ab51c128.git /tmp/authorized_keys && \
    # cp /tmp/authorized_keys/authorized_keys ~ && \

USER ${USER}
WORKDIR /home/%{USER}
COPY authorized_keys /home/${USER}/.ssh/authorized_keys
RUN ssh-keygen -f /home/${USER}/.ssh/id_rsa -t rsa -N '' && \
    chmod 600 ~/.ssh/authorized_keys && \
    git config --global user.email rinat.sabitov@gmail.com && \
    git config --global user.name Rinat Sabitov && \
    git clone https://github.com/histrio/dotfiles.git && \
    ln -s dotfiles/* ~/ && \
    git clone "https://github.com/VundleVim/Vundle.vim.git" ~/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall chdir=/tmp > /dev/null && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts

EXPOSE 22/tcp
EXPOSE 60000-61000/udp

ENTRYPOINT ["/usr/sbin/sshd", "-De"]
