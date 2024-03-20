#!/bin/bash

# Display the menu to the user
echo "Please select a suite to run:"
echo "1. C Suite"
echo "2. Python Suite"
echo "3. Exit"

# Read the user's selection
read -p "Enter your choice: " suite

# Based on the selection, perform the action
case $suite in
    1)
        echo "You selected the C Suite."
        cd ~/checker/checker_suite/c_suite
        read -p "Enter task directory to run (or 'all' to run all tasks): " task
        if [ $task = "all" ]; then
            for dir in $(ls -d */); do
                cd $dir/checker
                for file in $(ls *.sh); do
                    bash $file
                done
                cd ../..
            done
        else
            cd $task/checker
            for file in $(ls *.sh); do
                bash $file
            done
            cd ../..
        fi
        ;;
    2)
        echo "You selected the Python Suite."
        # Similar changes would go here for the Python Suite
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac
