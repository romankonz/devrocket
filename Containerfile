FROM archlinux:latest
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        fd \
        fzf \
        git \
        go \
        jq \
        kubectl \
        lua51 \
        lua51-jsregexp \
        luarocks \
        neovim \
        nodejs-lts-iron \
        npm \
        openssh \
        python \
        python-pip \
        ripgrep \
        starship \
        sudo \
        tree-sitter \
        tree-sitter-cli \
        wget \
        yq \
        zsh \ 
    && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg

RUN useradd -m -s /usr/sbin/zsh rk
RUN echo "rk ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rk
USER rk:rk
COPY --chown=rk:rk dotfiles/ /home/rk
WORKDIR /home/rk

RUN mkdir /tmp/i && \
    cd /tmp/i && \
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    yay -S --noconfirm \
        dyff \
        openshift-client-bin \
        && \
    sudo rm -rf /tmp/i && \
    rm -rf /home/rk/.cache
RUN nvim --headless +"Lazy! sync" +qall && \
    nvim --headless +"TSInstallSync \
        bash \
        dockerfile \
        go \
        javascript \
        json \
        php \
        python \
        yaml \
        " \
        +qall && \
    nvim --headless +"LspInstall \
        bashls \
        dockerls \
        docker_compose_language_server \
        gopls \
        lua_ls \
        yamlls \
        " \
        +qall && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc && \
    rm -rf /home/rk/.cache

CMD ["/usr/sbin/zsh"]
