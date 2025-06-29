# Chromium Browser One-Click Setup

A simple, automated installer for Chromium browser optimized for KDE desktop and noVNC environments.

## 🚀 Quick Start

```bash
# Navigate to the setup directory
cd tools-setup-chromium

# Make the installer executable
chmod +x install-chromium.sh

# Run the one-click installer
./install-chromium.sh
```

## 📋 What This Setup Does

### ✅ Automatic Installation
- Updates system package list
- Installs Chromium browser via snap package
- Verifies successful installation

### ✅ VNC Optimization
- Creates VNC-optimized launcher with performance flags
- Configures Chromium for remote desktop usage
- Disables problematic features for VNC environments

### ✅ Desktop Integration
- Creates desktop shortcut
- Integrates with system applications menu
- Sets up proper MIME type associations

### ✅ Documentation Generation
- Creates comprehensive usage guide
- Provides troubleshooting information
- Includes integration notes for KDE + noVNC setup

## 🏗️ File Structure

```
tools-setup-chromium/
├── install-chromium.sh      # Main installer script
├── README.md               # This documentation
└── CHROMIUM_USAGE.md       # Generated after installation
```

## ⚙️ Installation Features

### System Requirements Check
- Verifies Ubuntu/Debian compatibility
- Checks internet connectivity
- Ensures non-root execution

### VNC-Optimized Configuration
The installer creates a special launcher (`~/.local/bin/chromium-vnc`) with these optimizations:

```bash
--no-sandbox                           # Disable sandbox for VNC compatibility
--disable-dev-shm-usage               # Reduce shared memory usage
--disable-gpu-sandbox                 # Disable GPU sandbox
--disable-software-rasterizer         # Optimize rendering
--disable-background-timer-throttling # Prevent background throttling
--no-first-run                        # Skip first-run setup
--no-default-browser-check            # Skip default browser prompt
```

## 🌐 Integration with KDE + noVNC

This setup is specifically designed to work with your existing KDE desktop + noVNC environment:

### Multi-User Support
- Each VNC user can run their own Chromium instance
- Works with existing port allocation (5901, 5902, 5903...)
- Compatible with noVNC web interface on ports 6080, 6081, 6082...

### Access Methods
1. **Via noVNC Web Interface**: `http://localhost:6080/vnc.html`
2. **Direct VNC Client**: Connect to `localhost:5901`
3. **SSH Tunnel**: For secure remote access

### Performance Considerations
- Optimized flags reduce resource usage
- Better compatibility with remote desktop protocols
- Reduced GPU dependencies for headless environments

## 🔧 Usage Examples

### Standard Launch
```bash
chromium
```

### VNC-Optimized Launch (Recommended)
```bash
~/.local/bin/chromium-vnc
```

### With Custom Flags
```bash
chromium --incognito --new-window https://example.com
```

## 🛠️ Troubleshooting

### Common Issues

#### Installation Fails
```bash
# Check system compatibility
lsb_release -a

# Verify internet connection
ping -c 3 google.com

# Re-run installer
./install-chromium.sh
```

#### Chromium Won't Start in VNC
```bash
# Use VNC-optimized launcher
~/.local/bin/chromium-vnc

# Or launch with no-sandbox flag
chromium --no-sandbox
```

#### Performance Issues
1. Use the VNC-optimized launcher
2. Disable hardware acceleration in Chromium settings
3. Reduce browser window size
4. Close unnecessary tabs

### Log Files
- Installation logs: Check terminal output during installation
- Chromium logs: `~/.config/chromium/chrome_debug.log`
- System logs: `journalctl -u snapd.service`

## 🔒 Security Considerations

### Sandbox Disabled
The VNC-optimized launcher disables Chromium's sandbox for compatibility. This is safe in controlled environments but consider:

- Use only in trusted networks
- Avoid downloading suspicious files
- Keep Chromium updated
- Use incognito mode for sensitive browsing

### Network Security
- VNC traffic is unencrypted by default
- Use SSH tunneling for remote access
- Consider VPN for production environments

## 📝 Customization

### Adding Custom Flags
Edit the VNC launcher script:
```bash
nano ~/.local/bin/chromium-vnc
```

### Creating Additional Launchers
```bash
# Create custom launcher
cp ~/.local/bin/chromium-vnc ~/.local/bin/chromium-custom

# Edit with your preferred flags
nano ~/.local/bin/chromium-custom
```

## 🔄 Updates

### Updating Chromium
```bash
# Chromium updates automatically via snap
sudo snap refresh chromium

# Check current version
chromium --version
```

### Updating This Setup
```bash
# Re-run the installer to update configurations
./install-chromium.sh
```

## 🤝 Integration with Main KDE + noVNC Project

This tool complements your main KDE desktop + noVNC installer:

### Modular Design
- Standalone installation for Chromium
- Compatible with existing user accounts (x2, x3, x4...)
- Works with existing service configurations

### Service Integration
- No additional systemd services required
- Uses existing VNC user sessions
- Compatible with existing noVNC setup

### Multi-User Considerations
```bash
# Install for specific VNC user
sudo -u x2 ./install-chromium.sh

# Or install system-wide (current approach)
./install-chromium.sh
```

## 📊 Verification

After installation, verify everything works:

```bash
# Check installation
chromium --version

# Test VNC launcher
~/.local/bin/chromium-vnc --version

# Verify desktop shortcut
ls -la ~/Desktop/Chromium.desktop

# Check documentation
cat CHROMIUM_USAGE.md
```

## 📞 Support

For issues:
1. Check `CHROMIUM_USAGE.md` (generated after installation)
2. Review troubleshooting section above
3. Check main KDE + noVNC project documentation
4. Verify system compatibility and requirements

---

**Part of the KDE Desktop + noVNC One-Click Installer Suite**  
**Version: 1.0**  
**Compatible with: Ubuntu 20.04+, Debian-based systems**
