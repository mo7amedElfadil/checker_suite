#!/usr/bin/env python3
"""
    Module that defines methods to create project directory and files for
    each task in the project for the checker suite.
"""
import os
from requests import Session
from login import change_curr
from html_getter import get_html, save_html
from parsers import get_data, get_tasks
from requests.cookies import RequestsCookieJar


def create_project(data: dict) -> None:
    """
        creates project directory and files for each task in the project
        Args:
            data - dict with keys project_title and project_description,
                repository, directory, tasks

        Description of data:
            project_title: str - title of the project
            project_description: str - description of the project
            repository: str - name of the repository
            directory: str - name of directory to store project files
            tasks: list of dicts - list of tasks in the project with keys being
                    task names and values being task descriptions
        Returns:
            None
    """
    criteria: dict[str, str | dict[str, str]] = {
            'alx-low_level_programming': 'c_suite',
            'alx-higher_level_programming': {"Python":'py_suite',
                                             "JavaScript": 'js_suite'},
                'alx-backend-javascript': 'js_suite',
                'alx-backend-python': 'py_suite',}
    project_title: str = data['project_title']
    project_description: str = data['project_description']
    repository: str = data['repository']
    directory: str = data['directory']
    tasks: list[dict[str, str]] = data['tasks']
    goto: str = ''

    if repository in criteria:
        repo_criteria = criteria[repository]
        if type(repo_criteria) == dict:
            for key, value in repo_criteria.items():
                if key.lower() in project_title.lower():
                    goto = f'projects/{value}'
                    break
        else:
            goto = f'projects/{repo_criteria}'
    else:
        return

    if not os.path.exists(goto):
        print(f"Creating suite directory {goto}")
        os.mkdir(goto)
    os.chdir(goto)
    if not os.path.exists(directory):
        print(f"Creating project directory {directory}")
        os.mkdir(directory)
    os.chdir(directory)
    with open('README.md', 'w') as f:
        f.write(f"# {project_title}\n\n{project_description}")
    for task in tasks:
        for key in task:
            task_files: str | None = None
            if 'task' in key:
                continue
            task_num : str = key.split(' ')[0][0:-1]
            task_files = task['task_files']
            with open(f'{task_num}.md', 'w') as f:
                f.write((
                         f"# {key}\n\n{task[key]}\n\n"
                         f" - repository: {repository}\n"
                         f" - directory: {directory}\n"
                         f" - files: {task_files}\n"
                         ))
    os.chdir('../../..')



def create_files(session: Session, domain: str,
                 cookies: RequestsCookieJar, curr: int,
                 project_id: int) -> int:
    """
        creates project directory and files for each task in the project
        Args:
            session: requests.Session - session to use for requests
            domain: str - domain of the intranet
            cookies: RequestsCookieJar - cookies to use for requests
            curr: int - current curriculum
            project_id: int - project id
        Returns:
            int
    """
    curriculums: list[str] = ['foundation', 'specialization']
    try:
        html_content: str = get_html(session,
                                     domain, 'projects', project_id,
                                     cookies=cookies)
        data: dict = get_tasks(html_content, get_data(html_content))
        if not data:
            print(f'Trying to change curriculum from {curriculums[curr]}' +
                  f'to {curriculums[not curr]}')
            curr = not curr
            cookies = change_curr(session, domain, curr)
            html_content = get_html(session, domain, 'projects',
                                    project_id, cookies=cookies)
            data = get_tasks(html_content, get_data(html_content))
        if not data:
            print(f'Project {project_id} is not accessible')
        create_project(data)
    except Exception as e:
        print(project_id, e)
    return curr
