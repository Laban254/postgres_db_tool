#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' 

LOG_FILE="/tmp/db_script.log"

display_separator() {
    echo -e "${CYAN}====================================${NC}"
}

log_message() {
    local message="$1"
    echo -e "${message}" | tee -a "$LOG_FILE"
}

create_database() {
    display_separator
    log_message "${BLUE}Create a New Database${NC}"
    display_separator

    read -p "${YELLOW}Enter the database name:${NC} " db_name
    read -p "${YELLOW}Enter the database user:${NC} " db_user
    read -sp "${YELLOW}Enter the database password:${NC} " db_pass
    echo

    db_name_escaped=$(printf "%q" "$db_name")
    db_user_escaped=$(printf "%q" "$db_user")
    db_pass_escaped=$(printf "%q" "$db_pass")

    create_db="CREATE DATABASE \"$db_name_escaped\";"
    create_user="CREATE USER \"$db_user_escaped\" WITH ENCRYPTED PASSWORD '$db_pass_escaped';"
    grant_privs="GRANT ALL PRIVILEGES ON DATABASE \"$db_name_escaped\" TO \"$db_user_escaped\";"

    log_message "${CYAN}Creating database...${NC}"
    if ! sudo -u postgres psql -c "$create_db" 2>/tmp/db_create_error.log; then
        log_message "${RED}Error creating database. See /tmp/db_create_error.log for details.${NC}"
        exit 1
    fi

    log_message "${CYAN}Creating user...${NC}"
    if ! sudo -u postgres psql -c "$create_user" 2>/tmp/db_user_error.log; then
        log_message "${RED}Error creating user. See /tmp/db_user_error.log for details.${NC}"
        exit 1
    fi

    log_message "${CYAN}Granting privileges...${NC}"
    if ! sudo -u postgres psql -c "$grant_privs" 2>/tmp/db_grant_error.log; then
        log_message "${RED}Error granting privileges. See /tmp/db_grant_error.log for details.${NC}"
        exit 1
    fi

    log_message "${GREEN}Database setup completed successfully.${NC}"
}

delete_database() {
    display_separator
    log_message "${BLUE}Delete an Existing Database${NC}"
    display_separator

    log_message "${CYAN}Fetching available databases...${NC}\n"
    databases=$(sudo -u postgres psql -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | awk '{$1=$1};1' | sort)

    if [ -z "$databases" ]; then
        log_message "${RED}No databases found.${NC}"
        exit 1
    fi

    log_message "${YELLOW}Available Databases:${NC}"
    echo "$databases" | awk '{print NR".", $1}' | column -t

    read -p "${YELLOW}Enter the number of the database to delete:${NC} " db_choice

    db_name=$(echo "$databases" | sed -n "${db_choice}p")

    if [ -z "$db_name" ]; then
        log_message "${RED}Invalid choice. Exiting.${NC}"
        exit 1
    fi

    read -p "${YELLOW}Are you sure you want to delete the database '$db_name'? (yes/no):${NC} " confirm
    if [[ "$confirm" != "yes" ]]; then
        log_message "${BLUE}Deletion cancelled.${NC}"
        exit 0
    fi

    delete_db="DROP DATABASE \"$db_name\";"

    log_message "${CYAN}Deleting database...${NC}"
    if ! sudo -u postgres psql -c "$delete_db" 2>/tmp/db_delete_error.log; then
        log_message "${RED}Error deleting database. See /tmp/db_delete_error.log for details.${NC}"
        exit 1
    fi

    log_message "${GREEN}Database deletion completed successfully.${NC}"
}

show_help() {
    display_separator
    log_message "${CYAN}Usage:${NC}"
    log_message "${YELLOW}1. Create a new database${NC} - Allows you to create a new database with specified credentials."
    log_message "${YELLOW}2. Delete an existing database${NC} - Allows you to delete an existing database from the list."
    log_message "${CYAN}Ensure you have sufficient privileges to perform these actions.${NC}"
    display_separator
}

check_permissions() {
    if [ "$EUID" -ne 0 ]; then
        log_message "${RED}Please run the script with sudo to ensure proper permissions.${NC}"
        exit 1
    fi
}

check_permissions
display_separator
log_message "${BLUE}Choose an option:${NC}"
log_message "1. ${GREEN}Create a new database${NC}"
log_message "2. ${RED}Delete an existing database${NC}"
log_message "3. ${CYAN}Help${NC}"
read -p "${BLUE}Enter your choice (1, 2, or 3):${NC} " choice

case $choice in
    1)
        create_database
        ;;
    2)
        delete_database
        ;;
    3)
        show_help
        ;;
    *)
        log_message "${RED}Invalid option. Please choose 1, 2, or 3.${NC}"
        exit 1
        ;;
esac
