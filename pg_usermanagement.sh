#!/bin/bash

# Function to display help
usage() {
    echo "Usage: $0 -u <username> -a <add|remove>"
    exit 1
}

# Parse command-line arguments
while getopts ":u:a:h" opt; do
    case ${opt} in
        u)
            USERNAME=$OPTARG
            ;;
        a)
            ACTION=$OPTARG
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

# Ensure both parameters are provided
if [ -z "$USERNAME" ] || [ -z "$ACTION" ]; then
    usage
fi

# Set PostgreSQL user and database (modify as needed)
PGUSER="postgres"  # PostgreSQL superuser
DBNAME="postgres"  # Default database

# Function to add user
add_user() {
    sudo -u $PGUSER psql -d $DBNAME -c "CREATE USER $USERNAME WITH PASSWORD 'changeme';" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "User $USERNAME added successfully."
    else
        echo "Failed to add user $USERNAME."
        exit 1
    fi
}

# Function to remove user
remove_user() {
    sudo -u $PGUSER psql -d $DBNAME -c "DROP USER $USERNAME;" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "User $USERNAME removed successfully."
    else
        echo "Failed to remove user $USERNAME."
        exit 1
    fi
}

# Execute action based on input
case "$ACTION" in
    add)
        add_user
        ;;
    remove)
        remove_user
        ;;
    *)
        echo "Invalid action: $ACTION. Use 'add' or 'remove'."
        exit 1
        ;;
esac
