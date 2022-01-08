ACTION_TARGETS := directory locale
ZSHPATH = $(shell which zsh)

.PHONY: $(shell grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/:.*//')

all: apt-install zsh batcat docker python apt-file avahi emacs ffmpeg rust tmux directory locale nas

# https://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


################################################################################
# Install by apt
################################################################################

apt-install:  ## Install applications
	@sudo apt update
	@sudo apt install -y git fzf fd-find

zsh:  ## Install zsh and set as default shell
	@sudo apt update
	@sudo apt install -y zsh
	@sudo chsh -s $(ZSHPATH) ${USER}
ifeq ($(wildcard ~/.zplug/.),)
	@curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
endif

batcat:  ## Setup bat
	@sudo apt update
	@sudo apt install -y bat 
	@ln -fs /usr/bin/batcat ~/.local/bin/bat

docker:  ## Setup docker
ifeq (,$(shell uname -r | grep WSL))
	@sudo apt update
	@sudo apt install -y ca-certificates curl gnupg lsb-release
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	@echo "deb [arch=$(shell dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	@sudo apt update
	@sudo apt install -y docker-ce docker-ce-cli containerd.io
	@-sudo groupadd docker
	@-sudo gpasswd -a ${USER} docker
	@sudo systemctl restart docker
ifeq (Linux,$(shell uname -s))
ifeq (armv7l,$(shell uname -m))
	@sudo curl -L https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-armv7 -o /usr/local/bin/docker-compose
	@sudo chmod +x /usr/local/bin/docker-compose
endif
endif
endif

python:  ## Setup python dev environment
	@sudo apt update
	@sudo apt install -y python3 python3-pip ipython3 
	@pip3 install multidict yarl async_timeout idna_ssl aiosignal aiohttp nndownload tinydb peewee pocket-api BeautifulSoup4 toml emoji feedparser youtube-dl tqdm

apt-file:  ## Setup apt-file
	@sudo apt update
	@sudo apt install -y apt-file
	@sudo apt-file update

avahi:  ## Setup mDNS
ifeq (,$(shell uname -r | grep WSL))
	@sudo apt update
	@sudo apt install -y avahi-daemon avahi-utils
	@sudo systemctl start avahi-daemon
	@sudo systemctl enable avahi-daemon
endif

emacs:  ## Buid and install emacs 27.1
ifeq (,$(shell which emacs))
	@./build_emacs.sh 27.1
endif
	@sudo apt update
	@sudo apt install -y cmigemo
	@sudo apt install -y texinfo  # For magit


ffmpeg:  ## Build and install ffmpeg 4.4
ifeq (,$(shell which ffmpeg))
	@./build_ffmpeg.sh 4.4
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

tmux:  ## Setup tmux
	@sudo apt update
	@sudo apt install -y tmux
ifeq ($(wildcard ~/.tmux/plugins/tpm/.),)  # https://stackoverflow.com/questions/20763629/
	@git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
endif

directory:  ## Create my normal directories
	@mkdir -p ~/projects ~/tmp ~/gits ~/.local/bin

locale:  ## Set locale
	@sudo apt update
	@sudo apt install -y locales-all
	@sudo update-locale LANG=en_US.UTF-8

nas:  ## Setup NAS
	@sudo apt update
	@sudo apt install -y nfs-common
	@sudo mkdir -p /mnt/nas
	@sudo echo "nas.local:/Public	/mnt/nas	nfs" | sudo tee -a /etc/fstab > /dev/null
	@sudo mount -a
