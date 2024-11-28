#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -h <host> -P <port> -u <user> -p <password> -d <database>"
    exit 1
}

# Parsing input arguments
while getopts "h:P:u:p:d:" opt; do
    case $opt in
        h) HOST="$OPTARG" ;;
        P) PORT="$OPTARG" ;;
        u) USER="$OPTARG" ;;
        p) PASSWORD="$OPTARG" ;;
        d) DATABASE="$OPTARG" ;;
        *) usage ;;
    esac
done

# Check if all required arguments are provided
if [ -z "$HOST" ] || [ -z "$PORT" ] || [ -z "$USER" ] || [ -z "$PASSWORD" ] || [ -z "$DATABASE" ]; then
    usage
fi

# Exporting the password for non-interactive authentication
export PGPASSWORD="$PASSWORD"

# SQL to terminate connections
SQL="SELECT pg_terminate_backend(pg_stat_activity.pid)
     FROM pg_stat_activity
     WHERE pg_stat_activity.datname = '$DATABASE'
       AND pid <> pg_backend_pid();"

echo "Terminating connections to database '$DATABASE' on $HOST:$PORT..."

# Execute the SQL command
psql -h "$HOST" -p "$PORT" -U "$USER" -d postgres -c "$SQL"

# Unset the password variable for security
unset PGPASSWORD

echo "Connections to database '$DATABASE' have been terminated."
