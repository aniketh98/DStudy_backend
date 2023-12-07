#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Define the directory to store output files and PID file
OUTPUT_DIR="/home/ubuntu/DStudy_backend/logs"
PID_FILE="/home/ubuntu/DStudy_backend/backend.pid"
mkdir -p "$OUTPUT_DIR"

# Define the path to your Java application JAR file
JAVA_APP_PATH="/home/ubuntu/DStudy_backend/target/backend-0.0.1-SNAPSHOT.jar"

# Define the port your Java application uses
PORT=8080

# Function to start the Java application
start_app() {
    PID=$(lsof -t -i:$PORT)
    if [ ! -z "$PID" ]; then
        echo "Port $PORT is in use by PID $PID. Killing the process."
        kill -9 $PID
        sleep 2 # Wait for the process to be killed
    fi

    CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    nohup java -jar "$JAVA_APP_PATH" --server.port=$PORT > "$OUTPUT_DIR/java_app_output_$CURRENT_DATE.log" 2>&1 &
    sudo echo $! > "$PID_FILE"
    echo "Java application started."
}

# Function to stop the Java application
stop_app() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if [ ! -z "$PID" ] && [ -e /proc/$PID ]; then
            echo "Stopping Java application running on port $PORT."
            kill -9 $PID
            rm "$PID_FILE"
        else
            echo "No Java application found running on port $PORT."
        fi
    else
        echo "PID file not found. Cannot determine if Java application is running."
    fi
}

build_app() {
    echo "Building the backend app..."
    mvn clean install
}

# Function to restart the Java application
restart_app() {
    echo "Restarting Java application..."
    stop_app
    sleep 2
    start_app
}

# Check the command-line argument
case "$1" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        restart_app
        ;;
    build)
        build_app
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

