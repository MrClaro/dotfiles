#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
	echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if command exists
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Function to check if running on Arch-based system
check_arch() {
	if ! command_exists pacman; then
		print_error "This script is designed for Arch-based systems (pacman not found)"
		exit 1
	fi
}

install_arch_packages() {
	print_status "Installing Arch packages..."

	# Check if yay is installed for AUR packages
	if ! command_exists yay; then
		print_warning "yay not found. Installing yay first..."
		sudo pacman -S --needed base-devel git
		git clone https://aur.archlinux.org/yay.git
		cd yay && makepkg -si --noconfirm
		cd .. && rm -rf yay
	fi

	# Install packages
	sudo pacman -S --needed ghostty ghostty-terminfo ghostty-shell-integration \
		neovim tmux luarocks git ripgrep fzf thefuck ruby docker \
		spotify-launcher lazygit eza || {
		print_error "Failed to install some packages"
		return 1
	}

	print_status "Arch packages installed successfully!"
}

install_postman() {
	print_status "Installing Postman..."

	if ! command_exists yay; then
		print_error "yay is required for installing Postman. Please install Arch packages first."
		return 1
	fi

	yay -S --noconfirm postman-bin || {
		print_error "Failed to install Postman"
		return 1
	}

	print_status "Postman installed successfully!"
}

install_sdkman() {
	print_status "Installing SDKMAN..."

	if [ -d "$HOME/.sdkman" ]; then
		print_warning "SDKMAN already installed, skipping..."
		return 0
	fi

	curl -s "https://get.sdkman.io" | bash || {
		print_error "Failed to install SDKMAN"
		return 1
	}

	# Source SDKMAN for current session
	source "$HOME/.sdkman/bin/sdkman-init.sh"

	print_status "SDKMAN installed successfully!"
}

install_fish() {
	print_status "Installing Fish shell..."

	# Install fish
	sudo pacman -S --needed fish || {
		print_error "Failed to install Fish"
		return 1
	}

	# Ask before changing default shell
	echo -e "${BLUE}Do you want to set Fish as your default shell? (y/N):${NC}"
	read -r response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		chsh -s "$(which fish)" || {
			print_error "Failed to change default shell to Fish"
			return 1
		}
		print_status "Fish set as default shell. Please log out and log back in for changes to take effect."
	fi

	print_status "Fish shell installed successfully!"
}

install_shell_color_scripts() {
	print_status "Installing Shell Color Scripts..."

	if [ -d "$HOME/shell-color-scripts" ]; then
		print_warning "Shell Color Scripts directory exists, removing old version..."
		rm -rf "$HOME/shell-color-scripts"
	fi

	git clone https://gitlab.com/dwt1/shell-color-scripts.git "$HOME/shell-color-scripts" || {
		print_error "Failed to clone Shell Color Scripts"
		return 1
	}

	cd "$HOME/shell-color-scripts" || return 1
	makepkg -cf || {
		print_error "Failed to build Shell Color Scripts"
		return 1
	}

	sudo pacman -U --noconfirm *.pkg.tar.zst || {
		print_error "Failed to install Shell Color Scripts"
		return 1
	}

	cd "$HOME" || return 1
	rm -rf "$HOME/shell-color-scripts"

	print_status "Shell Color Scripts installed successfully!"
}

install_neovim_config() {
	print_status "Setting up NeoVim configuration..."

	# Backup existing config if it exists
	if [ -d "$HOME/.config/nvim" ]; then
		print_warning "Existing nvim config found, backing up to nvim.backup..."
		mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
	fi

	# Clone dotfiles to temp directory
	temp_dir=$(mktemp -d)
	git clone https://github.com/MrClaro/dotfiles.git "$temp_dir" || {
		print_error "Failed to clone dotfiles"
		rm -rf "$temp_dir"
		return 1
	}

	# Copy nvim config
	mkdir -p "$HOME/.config"
	cp -r "$temp_dir/nvim" "$HOME/.config/" || {
		print_error "Failed to copy nvim configuration"
		rm -rf "$temp_dir"
		return 1
	}

	# Clean up
	rm -rf "$temp_dir"

	print_status "NeoVim configuration installed successfully!"
}

install_oh_my_posh() {
	print_status "Installing Oh-My-Posh..."

	# Install Oh-My-Posh
	curl -s https://ohmyposh.dev/install.sh | bash -s || {
		print_error "Failed to install Oh-My-Posh"
		return 1
	}

	# Install FiraCode font
	oh-my-posh font install firacode || {
		print_warning "Failed to install FiraCode font, continuing anyway..."
	}

	print_status "Oh-My-Posh installed successfully!"
	print_warning "You may need to restart your terminal or run 'exec fish' to see changes"
}

install_homebrew() {
	print_status "Installing Homebrew..."

	# Install Ruby dependencies
	sudo pacman -S --needed ruby-json ruby-irb ruby-reline ruby-erb || {
		print_error "Failed to install Ruby dependencies"
		return 1
	}

	# Install Homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
		print_error "Failed to install Homebrew"
		return 1
	}

	print_status "Homebrew installed successfully!"
}

install_all() {
	print_status "Installing all components..."

	install_arch_packages
	install_postman
	install_sdkman
	install_fish
	install_shell_color_scripts
	install_neovim_config
	install_oh_my_posh
	install_homebrew

	print_status "All installations completed!"
	print_warning "Some changes may require a system restart or re-login to take effect."
}

show_menu() {
	echo ""
	echo -e "${BLUE}=== REVERSE AUTISM SETUP SCRIPT ===${NC}"
	echo -e "${YELLOW}(I'm Autistic BTW)${NC}"
	echo ""
	echo "Please select what you want to install:"
	echo ""
	echo "1) Arch Packages (ghostty, neovim, tmux, etc.)"
	echo "2) Postman"
	echo "3) SDKMAN"
	echo "4) Fish Shell"
	echo "5) Shell Color Scripts"
	echo "6) My NeoVim Config"
	echo "7) Oh-My-Posh"
	echo "8) Homebrew"
	echo "9) Install All"
	echo "10) Exit"

}

main() {
	# Check if running on Arch-based system
	check_arch

	while true; do
		show_menu
		echo -n "Enter your choice [1-10]: "
		read -r choice

		case $choice in
		1) install_arch_packages ;;
		2) install_postman ;;
		3) install_sdkman ;;
		4) install_fish ;;
		5) install_shell_color_scripts ;;
		6) install_neovim_config ;;
		7) install_oh_my_posh ;;
		8) install_homebrew ;;
		9) install_all ;;
		10)
			print_status "Goodbye!"
			exit 0
			;;
		*)
			print_error "Invalid option. Please choose 1-10."
			;;
		esac

		echo ""
		echo -e "${BLUE}Press Enter to continue...${NC}"
		read -r
	done
}

# Run main function
main
