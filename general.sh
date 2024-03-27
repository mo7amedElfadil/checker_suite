#!/bin/bash

# Display the menu to the user
echo "Please select a suite to run:"
echo "1. C Suite"
echo "2. Python Suite"
echo "3. Exit"

# Read the user's selection
read -p "Enter your choice: " suite

# Based on the selection, perform the action
checker_dir=$(find "$HOME" -type d -name "checker_suite")
case $suite in
    1)
        echo "You selected the C Suite."
        cd $checker_dir/c_suite
        echo "Available projects:"
        ls -d */
        read -p "Enter project directory to run (or 'all' to run all projects): " project
        if [ $project = "all" ]; then
            for dir in $(ls -d */); do
                cd $dir/checker
                echo "Running tasks in project $dir:"
                for file in $(ls *.sh); do
                    echo "Running task $file"
                    bash $file
                done
                cd ../..
            done
        else
            cd $project/checker
            echo "Available tasks in project $project:"
            ls *.sh
            read -p "Enter task to run (or 'all' to run all tasks): " task
            if [ $task = "all" ]; then
                for file in $(ls *.sh); do
                    echo "Running task $file"
                    bash $file
                done
            else
                echo "Running task $task"
                bash $task
            fi
            cd ../..
        fi
        ;;
    2)
        echo "You selected the Python Suite."
        cd $checker_dir/py_suite
        echo "Available projects:"
        ls -d */
        read -p "Enter project directory to run (or 'all' to run all projects): " project
        if [ $project = "all" ]; then
            for dir in $(ls -d */); do
                cd $dir/checker
                echo "Running tasks in project $dir:"
                for file in $(ls *.sh); do
                    echo "Running task $file"
                    bash $file
                done
                cd ../..
            done
        else
            cd $project/checker
            echo "Available tasks in project $project:"
            ls *.sh
            read -p "Enter task to run (or 'all' to run all tasks): " task
            if [ $task = "all" ]; then
                for file in $(ls *.sh); do
                    echo "Running task $file"
                    bash $file
                done
            else
                echo "Running task $task"
                bash $task
            fi
            cd ../..
        fi
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac
