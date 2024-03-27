# checker_suite

This repository is a combined effort from the #VIM_ARMY to compile a checker suite for our #ALX_SE tasks.

##  How to contribute

To contribute to this repository, please follow these steps:
1. Fork this repo
2. Create a new branch
3. Add your scripts and tests
4. Push your branch
5. Submit a pull request

### Sub projects to contribute to

If you wish to contribute, here are the details of what needs to be done in this project. We will divide ourselves into team. Each team's responsibility is outlined below:

**TASK COLLECTION TEAM**

- collecting data from task pages:
    - Task main file in main_files directory
        - Include expected output in the checker/output directory
        - create a sub directory in the main_files for the extended checks for edge cases
    - Task description in markdown file in project directory `0-swap.md`
    - Project readme contains the description of project, resources, and requirements
- Readme
    - Root readme includes project description, usage, installation, etc
    - Suite readme includes suggestions, bug notes, basically communication between contributors.
    - project readme as mentioned above, description of project, resources, and requirements
    - task readme/markdown describes the task and contains all the content related to this specific task i.e. question, main file, example output, task files (all usually found under the task title)

**CHECKER CODING TEAM**

- write generalized checker script for python, js, and SQL i.e. checker_functions.sh
- determine tasks that need specific/targeted checkers and write the code for them

**AI HELPER TEAM**

- Implement AI helper. It should provide:
    - Description of task
    - suggestions on how to fix bugs
    - suggestions on how to improve code even after passing all checkers

**WEB SCRAPER TEAM**

- Implement web scraper for obtaining all task data to aid the task collection team

## How to install

+ clone the repo
+ navigate to project location
+ run `./install.sh` in your terminal
+ Now you can run `checker` command from anywhere inside your system tree


<!-- TODO: -->
## Manual & Usage

After installation run `checker -h`

- flag `-a` to run all project's tasks in every suite.
- flag `-l` to provide the suite or language to run checker against.
- flag `-h` this is help.
- option `-p` to provide project argument(argument is mandatory).
- option `-t` to provide task argument.

_**Alternatively**_ you can run the command w/out any options,
then you'll be prompted w/ options to select from.
