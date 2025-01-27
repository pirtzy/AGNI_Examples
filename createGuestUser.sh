'''
Written BY Shai Perretz
version 1.0
last update 25.1.2025
contcat: shaip@arista.com

Simple script use AGNO TOKEN (Lunchpad)  to authenticate, get cookie
Using the cookie add new UPSK Guest user and display all users.

This is not an official script and should be used with caution.
There is no support for this script.
'''
import json
import requests
import csv
from datetime import datetime


RPC_TIMEOUT = 30  # in seconds
TOKENKEY = 'KEY-xxxxxxx1'
TOKENVALUE = '5cbe28xxxxxxxxxxxxxxxxxxxxxxxxxx'
ORG_ID = 'E01934dea-cxxxxxxxxxxxxxxxxxxxxxxxxxx'
SERVER = 'https://xxxxxxxxxx.agni.arista.io/'

HEADERS = {
    "Authorization": f"Bearer {TOKENVALUE}",
    "Content-Type": "application/json",
    "Accept": "application/json",
    'X-AGNI-ORG-ID': ORG_ID

}

exportall = {
    "exportAll": True,
    "filters": [
        {
            "field": "string",
            "value": "string"
        }
    ],
    "portalID": 0,
    "query": "string",
    "sponsorID": "string",
    "userIDList": [
        "string"
    ],
    "userType": "string"
}

userinfo = {
    "deviceLimit": 0,
    "email": "aeraer4@gmail.com",
    "loginName": "aeraer4@gmail.com",
    "orgID": ORG_ID,
    "portalID": 0,
    "validFrom": "2025-01-25T08:43:09.292Z",
    "validTo": "2025-01-28T08:43:09.292Z"
}


def GetCookie():
    response = requests.get(SERVER + 'cvcue/keyLogin?keyID=' + TOKENKEY + '&keyValue=' + TOKENVALUE, headers=HEADERS)
    mycookie = response.json()['data']
    mycookie = str.split(mycookie['cookie'],'=')
    cookiekey = mycookie[0]
    cookieval = mycookie[1]
    cookieval = str.split(cookieval, ';')[0]
    return {cookiekey:cookieval}

def AddUser(userinfo, cookie):
    response = requests.post(SERVER + 'api/identity.guest.user.add', headers=HEADERS, cookies=cookie, json=userinfo)
    return response.json()

def GetAllUsers(cookie):
    response = requests.post(SERVER + 'api/identity.guest.user.export', headers=HEADERS, cookies=cookie, json=exportall)
    return response.content.decode('utf-8')

def main():
    cookie = GetCookie()
    #AddUser(userinfo, cookie )
    AddUser(userinfo, cookie)
    GetAllUsers(cookie)



if __name__ == '__main__':

    main()