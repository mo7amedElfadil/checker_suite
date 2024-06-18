#!/usr/bin/env python3
"""
    Module that defines functions to login to the intranet.
    Depending on the curriculum, the user can login
    to the foundation or specialization curriculum.
"""
import requests
from requests.cookies import RequestsCookieJar
from bs4 import BeautifulSoup as bs, NavigableString, Tag


def change_curr(session: requests.Session, domain: str,
                curr: int = 0) -> RequestsCookieJar:
    """
        Change the curriculum of the user
        Parameters
        ----------
        session : requests.Session
            The session to use
        domain : str
            The domain of the intranet
        curr : int, optional
            The current curriculum,
            by default 0 (foundation) or 1 (specialization)
        Returns
        -------
        RequestsCookieJar : The cookies
    """
    if curr == 0:
        observe_url = '{}/curriculums/1/observe'.format(domain)
    else:
        observe_url = '{}/curriculums/17/observe'.format(domain, curr)
    return session.get(observe_url).cookies


def login(domain: str, email: str, password: str,
          curr: int = 0) -> tuple[requests.Session, RequestsCookieJar]:
    """
        Login to the intranet
        Parameters
        ----------
        domain : str
            The domain of the intranet
        email : str
            The email of the user
        password : str
            The password of the user
        curr : int, optional
            The current curriculum,
            by default 0 (foundation) or 1 (specialization)
        Returns
        -------
        tuple[requests.Session, RequestsCookieJar] | None : (session, cookies) | None
    """

    url: str = '{}/auth/sign_in'.format(domain)
    session: requests.Session = requests.Session()
    login_page: requests.Response = session.get(url)
    soup: bs = bs(login_page.content, 'html.parser')
    result: (Tag | NavigableString
             | None) = soup.find('input',
                                 {'name': 'authenticity_token'})
    if not result or not isinstance(result, Tag):
        print("Login failed: authenticity token not found")
        exit(1)
    token: str = str(result.get('value'))
    data: dict[str, str] = {
        'user[email]': email,
        'user[password]': password,
        'authenticity_token': token,
        'user[remember_me]': '0',
        'commit': 'Log in'
    }
    response: requests.Response = session.post(url, data=data)
    if response.status_code == 200:
        print("Login successful")
    else:
        print("Login failed")
        exit(1)
    return session, change_curr(session, domain, curr=curr)



