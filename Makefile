INSTALL_TARGETS := zsh tmux cmigemo fzf fd-find git python3 python3-pip bat emacs ffmpeg chsh rust zplug tpm pip3
ACTION_TARGETS := directory locale
ZSHPATH = $(shell which zsh)

.PHONY: $(shell grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/:.*//')

all: install action

install: $(INSTALL_TARGETS)

action: $(ACTION_TARGETS)

# https://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


################################################################################
# Install by apt
################################################################################

zsh: ## Install zsh
ifeq (,$(shell which zsh))
	@sudo apt install -y $@
endif

tmux: ## Install tmux
ifeq (,$(shell which tmux))
	@sudo apt install -y $@
endif

cmigemo:  ## Install cmigemo for Emacs
ifeq (,$(shell which cmigemo))
	@sudo apt install -y $@
endif

fzf:  ## Install fzf
ifeq (,$(shell which fzf))
	@sudo apt install -y $@
endif

fd-find:  ## Install fd-find
ifeq (,$(shell which fdfind))
	@sudo apt install -y $@
endif

git:  ## Install git
ifeq (,$(shell which git))
	@sudo apt install -y $@
endif

apt-file:  ## Install apt-file
ifeq (,$(shell which apt-file))
	@sudo apt install -y $@
	@sudo apt-file update
endif

python3:  ## Install python3
ifeq (,$(shell which python3))
	@sudo apt install -y $@
endif

python3-pip:  ## Install python3-pip
ifeq (,$(shell which pip3))
	@sudo apt install -y $@
endif

ipython3:  ## Install ipython3
ifeq (,$(shell which ipython3))
	@sudo apt install -y $@
endif


bat: directory ## Install bat
ifeq (,$(shell which bat))
	@sudo apt install -y $@
	@ln -s /usr/bin/batcat ~/.local/bin/bat
endif

avahi-daemon:  ## Install, start and enable avahi-daemon
ifeq (,$(shell which avahi-daemon))
	@sudo apt install -y $@
	@sudo systemctl start avahi-daemon
	@sudo systemctl enable avahi-daemon
endif

################################################################################
# Other installs
################################################################################

emacs:  ## Buid and install emacs 27.1
ifeq (,$(shell which emacs))
	@./build_emacs.sh 27.1
endif

ffmpeg:  ## Build and install ffmpeg 4.4
ifeq (,$(shell which ffmpeg))
	@./build_ffmpeg.sh 4.4
endif

chsh: zsh  ## Set default shell zsh
ifneq ($(ZSHPATH), $(shell grep ${USER} /etc/passwd | tr ':' '\n' | grep zsh))
	@chsh -s $(ZSHPATH)
endif

rust:  ## Install Rust
ifeq ($(wildcard ~/.cargo/.),)  # https://stackoverflow.com/questions/20763629/
ifeq ($(wildcard ~/.rustup/.),)
	@curl -sSLf https://sh.rustup.rs -o rustup-init.sh
	@chmod 755 rustup-init.sh
	@./rustup-init.sh -y -q --no-modify-path
	@rm rustup-init.sh
endif
endif

zplug: zsh git  ## Install zplug
ifeq ($(wildcard ~/.zplug/.),)
	@curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
endif

tpm: git  ## Install tpm (tmux plug-in manager)
ifeq ($(wildcard ~/.tmux/plugins/tpm/.),)  # https://stackoverflow.com/questions/20763629/
	@git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
endif

pip3: python3-pip  ## Install python modules
	@pip3 install multidict yarl async_timeout idna_ssl aiosignal aiohttp nndownload tinydb peewee \
	pocket-api BeautifulSoup4 toml emoji feedparser youtube-dl tqdm

################################################################################
# Actions
################################################################################

directory:  ## Create my normal dierecoties
	@mkdir -p ~/projects ~/tmp ~/gits ~/.local/bin

locale:  ## Set locale
	@sudo apt install -y locales-all
	@sudo update-locale LANG=en_US.UTF-8
