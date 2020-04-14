FROM centos:7

LABEL MAINTAINER="histrio <rinat.sabitov@gmail.com>"
ARG USER=histrio

RUN yum -y update && \
    yum -y install epel-release && \
    yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo && \
    yum -y install \
        openssh-server \
        vim \
        tmux \
        zsh \
        mosh \
        openssh-clients \
        curl \
        git \
        htop \
        openssh \
        python2-pip \
        net-tools \
        iputils \
        telnet \
        ack \
        fzf \
        man \
        ctags \
        wget \
        gcc \
        python2-devel \
        ripgrep && \
    pip install git-review ansible virtualenv && \
    useradd ${USER} -G wheel && \
    usermod -s /usr/bin/zsh ${USER} && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    ln -s --force /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    ssh-keygen -A

ENTRYPOINT ["/usr/sbin/sshd", "-De"]
EXPOSE 22/tcp 80/tcp 60000-61000/udp 8000-9000/tcp

USER ${USER}
WORKDIR /home/${USER}
COPY --chown=${USER}:${USER} authorized_keys /home/${USER}/.ssh/authorized_keys
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' && \
    chmod 600 ~/.ssh/authorized_keys && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/powerline/fonts.git /tmp/fonts --depth=1 && \
    /tmp/fonts/install.sh && rm -rf /tmp/fonts && \
    git clone "https://github.com/histrio/dotfiles.git" ~/dotfiles && \
    shopt -s dotglob && ln -sfv ~/dotfiles/* ~/ && \
    git clone "https://github.com/VundleVim/Vundle.vim.git" ~/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall chdir=/tmp > /dev/null
USER root
