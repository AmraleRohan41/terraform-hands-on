#!/usr/bin/env bash
set -euo pipefail

# Install and start nginx on common Linux distributions

if [ "$EUID" -ne 0 ]; then
	SUDO=sudo
else
	SUDO=
fi

echo "Installing nginx..."

if command -v apt-get >/dev/null 2>&1; then
	$SUDO apt-get update
	$SUDO apt-get install -y nginx
	$SUDO systemctl enable --now nginx
elif command -v dnf >/dev/null 2>&1; then
	$SUDO dnf install -y nginx
	$SUDO systemctl enable --now nginx
elif command -v yum >/dev/null 2>&1; then
	$SUDO yum install -y nginx
	$SUDO systemctl enable --now nginx
elif command -v apk >/dev/null 2>&1; then
	# Alpine Linux
	$SUDO apk add --no-cache nginx
	if command -v rc-update >/dev/null 2>&1; then
		$SUDO rc-update add nginx default
		$SUDO rc-service nginx start
	else
		$SUDO nginx -g 'daemon on;'
	fi
else
	echo "Unsupported distribution: no known package manager found" >&2
	exit 2
fi

echo "<h1> nginx installation complete. </h1>" | sudo tee /var/www/html/index.html

