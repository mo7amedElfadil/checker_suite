#!/usr/bin/env python3
"""
    Entry point for the web scraper application.
"""
import os
from dotenv import load_dotenv
from login import login
from create_project import create_files
from sys import argv
from json import dumps
from requests import Session
from requests.cookies import RequestsCookieJar

load_dotenv()
EMAIL: str = str(os.getenv('EMAIL'))
PASSWORD: str = str(os.getenv('PASSWORD'))
domain: str = str(os.getenv('DOMAIN'))


def pretty_print(data):
    """
        Pretty print the data
    """
    json_data: str = dumps(data, indent=4, ensure_ascii=True)
    print(json_data.encode('utf-8').decode('unicode_escape'))

def run_web_scraper():
    """
        Run the web scraper
    """
    curr: int
    project_id: int
    session: Session
    cookies: RequestsCookieJar
    start: int
    end: int
    if len(argv) > 1:
        curr = int(argv[1])
        project_id = int(argv[2])
    else:
        project_id = 1225
        curr = 0
    session, cookies = login(domain, EMAIL, PASSWORD, curr=curr)
    start = 212
    end = 250
    for i in range(start, end):
        curr = create_files(session, domain, cookies, curr, i)
    create_files(session, domain, cookies, curr, project_id)

if __name__ == '__main__':
    run_web_scraper()
    # pretty_print(data)
    # save_html(html_content, 'project_1225.html')
