#!/usr/bin/env python3
"""
    Module that defines functions to parse the html content of the project
    page and get the data and tasks.
"""
import re
from bs4 import BeautifulSoup as bs, Tag, NavigableString


def parse_data(info: Tag, dt: dict) -> None:
    """
        This function will parse the data from the project page and
        update the project description in the data dictionary
    """
    def process_item(item: Tag, dt: dict) -> None:
        """
            Process each item in the list and update the project description.
        """
        if item.name == "pre":
            dt['project_description'] += f"```{item.text}```\n"
        elif item.text != '\n':
            dt['project_description'] += f"\t - {item.text}\n"

    def process_title(title: Tag, dt: dict) -> None:
        """
            Process each title and update the project description.
        """
        if title.name == "ul":
            for item in title.contents:
                if isinstance(item, Tag):
                    process_item(item, dt)
        elif title.name == "pre":
            dt['project_description'] += f"```\n{title.text}```\n"
        elif title.text != '\n':
            dt['project_description'] += f"{title.text}\n"

    for title in info.contents:
        if isinstance(title, Tag):
            process_title(title, dt)


def get_data(html_content: str) -> dict:
    """
    This function will use the site in which the user provide
    to scrap data from the project page

    *Note*: This function has to be executed after setup

        Arguments:
            This function takes a BeautifulSoup object as the root
            of the DOM tree
    """
    dt: dict = {}
    soup: bs = bs(html_content, 'html.parser')
    result: (Tag | NavigableString
             | None)  = soup.find('div', id='project-description')
    if not result or not isinstance(result, Tag):
        print('No project description found')
        return dt
    info: Tag | NavigableString | None = result.div
    name: Tag | NavigableString | None = soup.find('h1')
    # print(name.text.strip(),'\n')
    if not name or not isinstance(name, Tag):
        print('No project title found')
        return dt
    dt['project_title'] = name.text.strip()
    dt['project_description'] = ''
    if not info or not isinstance(info, Tag):
        print('No project description found')
        return dt
    parse_data(info, dt)
    return dt


def get_tasks(html_content: str, data: dict):
    """
    This function will use the site to scrap data from the
    project page about the diffrent tasks

    *Note*: This function has to be executed after setup

        Arguments:
            This function takes a BeautifulSoup object as the
            root of the DOM tree
    """
    soup = bs(html_content, 'html.parser')
    tasks = soup.find_all('div', id=re.compile('task-num-\d+'))
    data['tasks'] = []
    tt = data['tasks']
    for task in tasks:
        name = task.h3.text.strip()
        tt.append({name: ''})
        task_files = task.find('div', class_='list-group-item')
        c = 0
        for item in task_files.ul:
            if item.name == 'li' and item.code:
                if c == 0:
                    data['repository'] = item.code.text
                elif c == 1:
                    data['directory'] = item.code.text
                else:
                    data['tasks'][-1]["task_files"] = item.code.text
                c += 1
        #     tt[-1]["task_files"] = {}
        #     if item.code:
        #         tt[-1]["task_files"] = task_files
        # print('='*20)
        # print(name)
        tasks_details = task.find('div', class_='panel-body')
        for item in tasks_details.contents:
            if item.name not in ['div', 'span']:
                if item.name == "pre":
                    tt[-1][name] += """```{}```\n""".format(item.text)
                    # print("""```\n{}```""".format(item.text))
                elif item.text != '\n':
                    tt[-1][name] += "{}\n".format(item.text)
                    # print("\t - {}".format(item.text))

    return data
