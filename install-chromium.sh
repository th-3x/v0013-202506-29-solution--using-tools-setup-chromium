#!/bin/bash
#==============================================================================
# Chromium Browser One-Click Installer
# Compatible with KDE Desktop + noVNC Environment
# Version: 1.0
#==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}  Chromium Browser Installer${NC}"
    echo -e "${BLUE}================================${NC}\n"
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
        print_error "This script should not be run as root"
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check if apt is available
    if ! command -v apt &> /dev/null; then
        print_error "apt package manager not found. This script is for Ubuntu/Debian systems."
        exit 1
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        print_warning "No internet connection detected. Installation may fail."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "System requirements check passed"
}

# Update package list
update_packages() {
    print_info "Updating package list..."
    if sudo apt update > /dev/null 2>&1; then
        print_success "Package list updated"
    else
        print_warning "Failed to update package list, continuing anyway..."
    fi
}

# Install Chromium
install_chromium() {
    print_info "Installing Chromium browser..."
    
    if sudo apt install -y chromium-browser; then
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

# Create desktop shortcut
create_desktop_shortcut() {
    print_info "Creating desktop shortcut..."
    
    DESKTOP_FILE="$HOME/Desktop/Chromium.desktop"
    
    cat > "$DESKTOP_FILE" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Chromium Web Browser
Comment=Access the Internet
GenericName=Web Browser
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=chromium %U
Terminal=false
X-MultipleArgs=false
Icon=chromium
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
EOF

    chmod +x "$DESKTOP_FILE"
    
    if [[ -f "$DESKTOP_FILE" ]]; then
        print_success "Desktop shortcut created"
    else
        print_warning "Failed to create desktop shortcut"
    fi
}

# Configure for VNC environment
configure_vnc_environment() {
    print_info "Configuring Chromium for VNC environment..."
    
    # Create chromium config directory if it doesn't exist
    CHROMIUM_CONFIG_DIR="$HOME/.config/chromium"
    mkdir -p "$CHROMIUM_CONFIG_DIR"
    
    # Create a script for optimized VNC launch
    VNC_LAUNCH_SCRIPT="$HOME/.local/bin/chromium-vnc"
    mkdir -p "$HOME/.local/bin"
    
    cat > "$VNC_LAUNCH_SCRIPT" << 'EOF'
#!/bin/bash
# Optimized Chromium launcher for VNC environment

# VNC-optimized flags
CHROMIUM_FLAGS=(
    --no-sandbox
    --disable-dev-shm-usage
    --disable-gpu-sandbox
    --disable-software-rasterizer
    --disable-background-timer-throttling
    --disable-backgrounding-occluded-windows
    --disable-renderer-backgrounding
    --disable-features=TranslateUI
    --disable-ipc-flooding-protection
    --no-first-run
    --no-default-browser-check
    --disable-default-apps
)

# Launch Chromium with optimized flags
exec chromium "${CHROMIUM_FLAGS[@]}" "$@"
EOF

    chmod +x "$VNC_LAUNCH_SCRIPT"
    
    if [[ -f "$VNC_LAUNCH_SCRIPT" ]]; then
        print_success "VNC-optimized launcher created at ~/.local/bin/chromium-vnc"
    fi
}

# Generate usage documentation
generate_documentation() {
    print_info "Generating usage documentation..."
    
    DOC_FILE="$(dirname "$0")/CHROMIUM_USAGE.md"
    
    cat > "$DOC_FILE" << 'EOF'
# Chromium Browser Usage Guide

## Installation Complete! 🎉

Chromium browser has been successfully installed and configured for your system.

## How to Launch Chromium

### Method 1: Command Line
```bash
# Standard launch
chromium

# VNC-optimized launch (recommended for remote desktop)
~/.local/bin/chromium-vnc
```

### Method 2: Desktop Environment
- Look for "Chromium Web Browser" in your applications menu
- Double-click the desktop shortcut (if created)

### Method 3: Via noVNC Web Interface
If you're using the KDE + noVNC setup:
1. Access your desktop via web browser: `http://localhost:6080/vnc.html`
2. Launch Chromium from the desktop or applications menu

## VNC-Optimized Features

The installation includes a VNC-optimized launcher with these improvements:
- Disabled GPU sandbox for better compatibility
- Reduced background processing
- Optimized for remote desktop performance
- No first-run setup prompts

## Useful Chromium Flags for VNC

```bash
# Launch with specific flags
chromium --no-sandbox --disable-gpu --disable-dev-shm-usage
```

## Troubleshooting

### Issue: Chromium won't start in VNC
**Solution**: Use the VNC-optimized launcher:
```bash
~/.local/bin/chromium-vnc
```

### Issue: Performance issues in remote desktop
**Solutions**:
1. Use the VNC-optimized launcher
2. Disable hardware acceleration in Chromium settings
3. Reduce browser window size

### Issue: Sandbox errors
**Solution**: Launch with `--no-sandbox` flag (already included in VNC launcher)

## Integration with KDE + noVNC Setup

Chromium works seamlessly with your existing setup:
- **Web Access**: Available through noVNC interface on port 6080
- **Multi-User**: Each VNC user can run their own Chromium instance
- **Performance**: Optimized for remote desktop usage

## Version Information

Check your Chromium version:
```bash
chromium --version
```

## Support

For issues related to:
- **Chromium**: Check official Chromium documentation
- **VNC Integration**: Refer to your KDE + noVNC setup documentation
- **Installation**: Re-run this installer script

---
Generated by Chromium One-Click Installer
EOF

    if [[ -f "$DOC_FILE" ]]; then
        print_success "Documentation generated: $DOC_FILE"
    fi
}

# Main installation function
main() {
    print_header
    
    print_info "Starting Chromium browser installation..."
    
    # Run installation steps
    check_root
    check_requirements
    update_packages
    install_chromium
    
    if verify_installation; then
        create_desktop_shortcut
        configure_vnc_environment
        generate_documentation
        
        print_success "Chromium browser installation completed successfully!"
        echo
        print_info "You can now launch Chromium using:"
        echo "  • Command: chromium"
        echo "  • VNC-optimized: ~/.local/bin/chromium-vnc"
        echo "  • Desktop shortcut or applications menu"
        echo
        print_info "Documentation available at: $(dirname "$0")/CHROMIUM_USAGE.md"
    else
        print_error "Installation completed but verification failed"
        exit 1
    fi
}

# Run main function
main "$@"
