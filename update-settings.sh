#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Enhanced VEIN Server Installer
# This script installs and configures a VEIN game server

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

INSTALL_PATH="/home/steam/Steam/vein-server"

# Function to display header
display_header() {
    clear
    echo -e "${BOLD}${BLUE}=======================================${NC}"
    echo -e "${BOLD}${BLUE}    VEIN Server Config Updater Script  ${NC}"
    echo -e "${BOLD}${BLUE}=======================================${NC}"
    echo ""
}

# Function to display section header
section_header() {
    echo ""
    echo -e "${BOLD}${CYAN}>> $1${NC}"
    echo -e "${CYAN}---------------------------------------${NC}"
}

# Function to run commands silently
run_silent() {
    echo -en "   ${YELLOW}⚙️  $1... ${NC}"
    if eval "$2" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        echo -e "   ${RED}Error executing: $2${NC}"
        return 1
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "${RED}Error: Please run as root (e.g., sudo $0)${NC}"
        exit 1
    fi
}

configure_server_config() {
    section_header "Updating Server Configuration"
    run_silent "Stopping vein server" "systemctl stop vein-server.service"
    CONFIG_DIR="${INSTALL_PATH}/Vein/Saved/Config/LinuxServer"
    ENGINE_INI_FILE="${CONFIG_DIR}/Engine.ini"
    echo -e "   ${YELLOW}⚙️  Updatingngine.ini configuration...${NC}"
    cat "${SCRIPT_DIR}/engine.ini" > "${ENGINE_INI_FILE}"
    run_silent "Restarting vein server" "systemctl start vein-server.service"
    echo -e "   ${GREEN}✓${NC}"
}

# Main function
main() {
    set -e # Exit on error
    
    check_root
    display_header
    
    echo -e "This script will update console configs for the server and restart it."
    echo -e "It will perform the following steps:"
    echo -e "  1. Stop vein server"
    echo -e "  2. Update engine.ini"
    echo -e "  3. Restart vein server"
    echo ""
    echo -e "Press ${BOLD}ENTER${NC} to begin or ${BOLD}CTRL+C${NC} to cancel..."
    read -r
    
    configure_server_config
    
}

# Execute main function
main
