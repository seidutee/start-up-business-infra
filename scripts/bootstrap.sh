#!/usr/bin/env bash
set -euo pipefail

# Detect package manager and service name
if command -v yum >/dev/null 2>&1; then
  PKG_MANAGER="yum"
  PKG_INSTALL="sudo yum install -y"
  SERVICE_NAME="httpd"
  WEB_ROOT="/var/www/html"
elif command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
  PKG_INSTALL="sudo DEBIAN_FRONTEND=noninteractive apt-get install -y"
  SERVICE_NAME="apache2"
  WEB_ROOT="/var/www/html"
else
  echo "Unsupported OS: no yum or apt-get found" >&2
  exit 1
fi

echo "Using package manager: ${PKG_MANAGER}"
echo "Installing web server (${SERVICE_NAME})..."

# Update repo cache for apt-based systems
if [ "${PKG_MANAGER}" = "apt" ]; then
  sudo apt-get update -y
fi

# Install package
${PKG_INSTALL} ${SERVICE_NAME}

# Start and enable service
sudo systemctl start ${SERVICE_NAME}
sudo systemctl enable ${SERVICE_NAME}

# Create a basic index.html for verification
sudo mkdir -p "${WEB_ROOT}"
sudo tee "${WEB_ROOT}/index.html" > /dev/null <<EOF
<!doctype html>
<html>
  <head><title>Bootstrap</title></head>
  <body>
    <h1>HTTPD Installed</h1>
    <p>Host: $(hostname -f 2>/dev/null || hostname)</p>
    <p>Installed at: $(date -u +"%Y-%m-%dT%H:%M:%SZ") (UTC)</p>
  </body>
</html>
EOF

# Ensure permissions
sudo chown -R root:root "${WEB_ROOT}"
sudo chmod -R 755 "${WEB_ROOT}"

echo "Bootstrap complete. Service '${SERVICE_NAME}' is running. Visit the instance IP to verify."
