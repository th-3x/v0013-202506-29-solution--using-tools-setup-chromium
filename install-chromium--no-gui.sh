#!/bin/bash
#==============================================================================
# Chromium Server/Headless One-Click Installer
# Compatible with Ubuntu Server (No GUI)
# Installs non-snap version via PPA for better performance.
# Version: 2.0
#==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${BLUE}  Chromium Server/Headless Installer   ${NC}"
    echo -e "${BLUE}=======================================${NC}\n"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root. Use sudo when prompted."
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    if ! command -v apt &> /dev/null; then
        print_error "apt package manager not found. This script is for Ubuntu/Debian systems."
        exit 1
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        print_warning "No internet connection. Installation may fail."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "System requirements check passed"
}

# Install dependencies and update package list
prepare_system() {
    print_info "Updating package list and installing dependencies..."
    
    # software-properties-common is needed for add-apt-repository
    if sudo apt update && sudo apt install -y software-properties-common; then
        print_success "Package list updated and dependencies installed"
    else
        print_error "Failed to update package list or install dependencies. Aborting."
        exit 1
    fi
}

# Install Chromium from PPA to avoid Snap
install_chromium() {
    print_info "Adding PPA to install Chromium (non-snap version)..."
    # Using a well-known PPA for Chromium .deb packages
    if sudo add-apt-repository ppa:xtradeb/apps -y; then
        print_success "PPA added successfully."
    else
        print_error "Failed to add PPA. Aborting."
        exit 1
    fi

    print_info "Updating package list from new PPA..."
    sudo apt update > /dev/null 2>&1

    print_info "Installing Chromium browser..."
    if sudo apt install -y chromium; then
        print_success "Chromium browser installed successfully"
    else
        print_error "Failed to install Chromium browser"
        exit 1
    fi
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    if command -v chromium &> /dev/null; then
        VERSION=$(chromium --version 2>/dev/null | head -n1)
        print_success "Chromium installed: $VERSION"
        return 0
    else
        print_error "Chromium installation verification failed"
        return 1
    fi
}

# Create a launcher script optimized for server/headless use
create_server_launcher() {
    print_info "Creating a launcher script for headless/server environment..."
    
    LAUNCHER_SCRIPT_DIR="$HOME/.local/bin"
    mkdir -p "$LAUNCHER_SCRIPT_DIR"
    
    LAUNCHER_SCRIPT_PATH="$LAUNCHER_SCRIPT_DIR/chromium-headless"
    
    cat > "$LAUNCHER_SCRIPT_PATH" << 'EOF'
#!/bin/bash
# Optimized Chromium launcher for headless/server environments

# Common flags for automation, testing, and running in containers
CHROMIUM_FLAGS=(
    --headless              # Run in headless mode (no UI)
    --no-sandbox            # Required for running as root in containers (use with caution)
    --disable-gpu           # Disable GPU hardware acceleration
    --disable-dev-shm-usage # Overcome limited resource problems in containers
    --window-size=1920,1080 # Set a default window size for screenshots
    --disable-features=TranslateUI
    --disable-extensions
    --disable-setuid-sandbox
    --no-first-run
    --no-zygote
)

# Launch Chromium with optimized flags and any additional user arguments
exec chromium "${CHROMIUM_FLAGS[@]}" "$@"
EOF

    chmod +x "$LAUNCHER_SCRIPT_PATH"
    
    if [[ -f "$LAUNCHER_SCRIPT_PATH" ]]; then
        print_success "Headless launcher created at: $LAUNCHER_SCRIPT_PATH"
        print_info "You may need to add '$LAUNCHER_SCRIPT_DIR' to your \$PATH."
    fi
}

# Generate usage documentation
generate_documentation() {
    print_info "Generating usage documentation..."
    
    DOC_FILE="$(dirname "$0")/CHROMIUM_SERVER_USAGE.md"
    
    cat > "$DOC_FILE" << 'EOF'
# Chromium on Server: Usage Guide

## ✅ Installation Complete!

Chromium browser has been successfully installed and configured for your server. This is a non-snap version, optimized for performance in a headless environment.

## 🚀 How to Launch Chromium

### Method 1: Standard Headless Launch

The installer created a helper script with recommended flags for server use.

```bash
# Recommended: Use the optimized launcher
~/.local/bin/chromium-headless [options] [url]

# Example: Create a PDF of a website
~/.local/bin/chromium-headless --print-to-pdf=output.pdf https://google.com

# Example: Take a screenshot
~/.local/bin/chromium-headless --screenshot=screenshot.png https://www.google.com
```

### Method 2: Direct Chromium Command

You can also use chromium directly with headless flags:

```bash
# Basic headless mode
chromium --headless --no-sandbox --disable-gpu

# Generate PDF
chromium --headless --no-sandbox --disable-gpu --print-to-pdf=output.pdf https://example.com

# Take screenshot
chromium --headless --no-sandbox --disable-gpu --screenshot=screenshot.png https://example.com
```

## 🔧 Common Use Cases

### Web Scraping and Automation
```bash
# Run with debugging port for automation tools
~/.local/bin/chromium-headless --remote-debugging-port=9222

# Run with custom user agent
~/.local/bin/chromium-headless --user-agent="Custom Bot 1.0"
```

### PDF Generation
```bash
# Generate PDF with custom page size
~/.local/bin/chromium-headless --print-to-pdf=document.pdf --print-to-pdf-no-header https://example.com

# Generate PDF with landscape orientation
~/.local/bin/chromium-headless --print-to-pdf=landscape.pdf --print-to-pdf-no-header --print-to-pdf-landscape https://example.com
```

### Screenshots
```bash
# Full page screenshot
~/.local/bin/chromium-headless --screenshot=fullpage.png --window-size=1920,1080 https://example.com

# Mobile viewport screenshot
~/.local/bin/chromium-headless --screenshot=mobile.png --window-size=375,667 https://example.com
```

## 🛠️ Troubleshooting

### Common Issues

#### Permission Errors
```bash
# If you get permission errors, try:
chromium --no-sandbox --headless --disable-gpu
```

#### Display Issues
```bash
# Set display variable if needed
export DISPLAY=:99
```

#### Memory Issues
```bash
# Reduce memory usage
~/.local/bin/chromium-headless --memory-pressure-off --max_old_space_size=4096
```

## 📝 Configuration

### Custom Launcher
You can modify the launcher script at `~/.local/bin/chromium-headless` to add your preferred default flags.

### Environment Variables
```bash
# Set default download directory
export CHROMIUM_DOWNLOAD_DIR="/path/to/downloads"

# Set custom user data directory
export CHROMIUM_USER_DATA_DIR="/path/to/userdata"
```

## 🔒 Security Notes

- The `--no-sandbox` flag is used for server compatibility
- Only use in trusted environments
- Consider running in containers for additional isolation
- Keep Chromium updated regularly

## 📊 Performance Tips

1. Use `--disable-gpu` for better headless performance
2. Set appropriate `--window-size` for your needs
3. Use `--disable-extensions` to reduce overhead
4. Consider `--disable-images` for faster page loads when images aren't needed

## 🔄 Updates

To update Chromium:
```bash
sudo apt update && sudo apt upgrade chromium-browser
```

---

**Installation completed successfully!**
**Chromium is ready for headless server use.**

EOF

    if [[ -f "$DOC_FILE" ]]; then
        print_success "Documentation generated: $DOC_FILE"
    fi
}

# Main execution
main() {
    print_header
    
    # Pre-installation checks
    check_root
    check_requirements
    
    # Installation process
    prepare_system
    install_chromium
    verify_installation
    
    # Post-installation setup
    create_server_launcher
    generate_documentation
    
    # Final success message
    echo
    print_success "🎉 Chromium installation completed successfully!"
    print_info "📖 Check CHROMIUM_SERVER_USAGE.md for usage instructions"
    print_info "🚀 Launch with: ~/.local/bin/chromium-headless"
    echo
}

# Run main function
main "$@"
