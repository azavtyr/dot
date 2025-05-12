#!/usr/bin/env python3

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

read -p 'Please input computer name or leave empty to keep current name: ' COMPUTER_NAME

if [[ -z $COMPUTER_NAME ]]; then
  echo 'Computer name will not be changed.'
else
  sudo scutil --set ComputerName "$COMPUTER_NAME"
  sudo scutil --set HostName "$COMPUTER_NAME"
  sudo scutil --set LocalHostName "$COMPUTER_NAME"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
  echo "New name: $COMPUTER_NAME"
fi

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Wipe all (default) app icons from the Dock
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others

# Delete the hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Make the animation when hiding/showing the Dock faster
defaults write com.apple.dock autohide-time-modifier -float 0

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -int 1

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Doesn't show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Hide desktop items
defaults write com.apple.finder CreateDesktop -bool false

# When performing a search, search the current folder by default
# Possible values:
# * SCev: This Mac
# * SCcf: Current Folder
# * SCsp: Previous Scope
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Set Downloads folder as the default location for new Finder windows.
# Possible values:
# * PfCm: Computer
# * PfVo: Volume
# * PfHm: $HOME
# * PfDe: Desktop
# * PfDo: Documents
# * PfAF: All My Files
# * PfLo: Other
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Never dim display when changing to battery
sudo pmset -b lessbright 0

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
