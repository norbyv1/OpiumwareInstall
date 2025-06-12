#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DYLIB_URL="https://f3a5dqxez3.ufs.sh/f/ijk9xZzvhn3rKZeMD8VSvnFxmAZq0zweH2aoMcuD16QW4Uty"
MODULES_URL="https://f3a5dqxez3.ufs.sh/f/ijk9xZzvhn3rwJp0FqnSaNpD4Ho6iG3rhmuMnx1sZYTzAvBt"
UI_URL="https://f3a5dqxez3.ufs.sh/f/ijk9xZzvhn3rNq6Tn4USxEfuUMmKTwplRc2bHa1sY6QIdo0q"

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while ps -p $pid &>/dev/null; do
        printf "\r${CYAN}[${spinstr:i++%${#spinstr}:1}] ${1}...${NC} "
        sleep $delay
    done

    wait $pid 2>/dev/null
    printf "\r${GREEN}[*] ${1} - done${NC}\n"
}

main() {
    clear
    echo -e "${CYAN}[ Opiumware Local Install Script | @nullctx && @norbyv1 ]${NC}"
    echo -e "${CYAN}----------------------------------------------------------${NC}"

    mkdir -p "$HOME/Applications"

    spinner "Fetching version information"
    json=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local version=$(echo "$json" | grep -o '"clientVersionUpload":"[^"]*' | grep -o '[^"]*$')

    if [ "$version" != "version-28c4061b835c48a3" ]; then
        echo -e "${RED}Opiumware has not yet updated to the latest version of Roblox ($version); aborting installation!${NC}"
        exit 1
    fi
    
    pkill -9 RobloxPlayer 2>/dev/null
    rm -rf "$HOME/Applications/Roblox.app"
    rm -rf "$HOME/Applications/Opiumware.app"
    (curl "https://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip") & spinner "Downloading Roblox - ($version)"
    wait & spinner "Installing Roblox"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app "$HOME/Applications/Roblox.app"
    rm ./RobloxPlayer.zip
    xattr -cr "$HOME/Applications/Roblox.app"
    (curl "$DYLIB_URL" -o "./libSystem.zip" && unzip -o -q "./libSystem.zip" && mv ./libSystem.dylib "$HOME/Applications/Roblox.app/Contents/Resources/libSystem.dylib" && curl -L "$MODULES_URL" -o modules.zip && unzip -o -q modules.zip) & spinner "Downloading modules"
    wait & spinner "Installing modules"
    spinner "Modifying client"
    ./Resources/Patcher "$HOME/Applications/Roblox.app/Contents/Resources/libSystem.dylib" "$HOME/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "$HOME/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "$HOME/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    codesign --force --deep --sign - "$HOME/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    spinner "Downloading interface assets"
    curl -L "$UI_URL" -o "./OpiumwareUI.zip"
    unzip -o -q "./OpiumwareUI.zip"
    rm -rf "$HOME/Opiumware/modules/luau-lsp" "$HOME/Opiumware/modules/Server"
    mkdir -p "$HOME/Opiumware"/{workspace,autoexec,themes,modules,modules/Server,modules/luau-lsp}
    mv -f Resources/Server "$HOME/Opiumware/modules/Server/server"
    mv -f Resources/luau-lsp "$HOME/Opiumware/modules/luau-lsp/luau-lsp"
    mv -f ./Opiumware.app "$HOME/Applications/Opiumware.app"
    rm -rf "$HOME/Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app" Resources/Patcher __MACOSX Resources libSystem.zip modules.zip OpiumwareUI.zip
    echo -e "${GREEN}[*] Finished install${NC}"
    echo -e "${GREEN}Launch Roblox from: $HOME/Applications/Roblox.app and Opiumware from: $HOME/Applications/Opiumware.app${NC}"
    exit
}

main
