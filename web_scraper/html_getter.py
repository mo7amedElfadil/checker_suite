#!/usr/bin/env python3
"""
    Module that defines functions to get html content from a url and
    save it to a file.
"""
import os
import requests
from requests.cookies import RequestsCookieJar

domain = os.getenv('DOMAIN')
context_curriculum_id = os.getenv('FOUNDATION_CONTEXT_CURRICULUM_ID')


def get_html(session: requests.Session, domain: str, path: str,
             project_id: int, cookies: RequestsCookieJar) -> str:
    """
        Get the html content of a page
        Parameters
        ----------
        session : requests.Session
            The session to use
        domain : str
            The domain of the intranet
        path : str
            The path of the url
        project_id : int
            The id of the project
        cookies : RequestsCookieJar
            The cookies to use
        Returns
        -------
        str : The html content of the page
    """
    url: str = '{domain}/{path}/{project_id}'.format(domain=domain, path=path,
                                                project_id=project_id)
    response: requests.Response = session.get(url, cookies=cookies)
    return response.text


def save_html(html: str, path: str) -> None:
    """
        Save the html content to a file
        Parameters
        ----------
        html : str
            The html content
        path : str
            The path of the file
    """
    with open(path, 'w') as file:
        file.write(html)
