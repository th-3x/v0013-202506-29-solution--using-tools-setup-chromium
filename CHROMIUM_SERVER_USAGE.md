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

