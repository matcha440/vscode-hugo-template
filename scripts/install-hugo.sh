#!/bin/bash
if [ -z $HUGO_VERSION ] ;then
  HUGO_VERSION="latest"
  API_ENDPOINT="https://api.github.com/repos/gohugoio/hugo/releases/latest"
else
  API_ENDPOINT="https://api.github.com/repos/gohugoio/hugo/releases/tags/v$HUGO_VERSION"
fi
HUGO_INSTALL_FILE="/tmp/hugo.deb"
DOWNLOAD_URL=$(curl -s $API_ENDPOINT \
| grep "browser_download_url.*hugo_[^extended].*_Linux-64bit\.deb" \
| cut -d ":" -f 2,3 \
| tr -d \")
if [ -z $DOWNLOAD_URL ] ;then
  echo "❌ ERROR: Failed to find download URL, please enter a valid Hugo version (ex. 0.74.2)"
  exit 1
fi
echo "🐻 Downloading Hugo ($HUGO_VERSION)..."
echo "Url: $DOWNLOAD_URL"
echo "Destination: $HUGO_INSTALL_FILE"

wget -q --output-document=$HUGO_INSTALL_FILE $DOWNLOAD_URL || \
  { echo "❌ ERROR: Failed to download Hugo"; exit 1; }

echo "Installing Hugo..."
sudo dpkg -i $HUGO_INSTALL_FILE || \
  { echo "❌ ERROR: Failed to install Hugo"; exit 1; }

echo "Install successful! 🌈"
echo "Removing $HUGO_INSTALL_FILE"
rm $HUGO_INSTALL_FILE

hugo version