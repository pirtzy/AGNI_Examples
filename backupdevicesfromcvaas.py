'''
Written BY Shai Perretz
version 1.0
last update 21.1.2025
contcat: shaip@arista.com

Simple backup script use TOKEN to authenticate,
Collect all switches listed as provisioned and save each switch's config to a file in the CONFIG_DIR directory

This is not an official script and should be used with caution.
There is no support for this script.
'''


import requests
from datetime import datetime

RPC_TIMEOUT = 30  # in seconds
TOKEN = open("token.txt", "r").read()
SERVER = 'https://www.cv-prod.xxxxxxxx.arista.io/cvservice/'
CONFIG_DIR = 'backups'

HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/json"
}


def main():

    switch_list = []
    response = requests.get('https://www.cv-prod-euwest-2.arista.io/cvpservice/inventory/devices?provisioned=true',headers=HEADERS)

    for switch in response.json():
        switch_list.append({
            'hostname':switch['hostname'],
            'systemMacAddress': switch['systemMacAddress'],
            'serialNumber': switch['serialNumber'],
            'deviceType': switch['deviceType'],
            'ipAddress': switch['ipAddress']

        })
    for switch in switch_list:
        today = datetime.today().strftime('%d-%m-%Y')
        filename = switch['hostname'] + '_' + today
        response = requests.get('https://www.cv-prod-euwest-2.arista.io/cvpservice/inventory/device/config?netElementId=' + switch['systemMacAddress'], headers=HEADERS)
        f = open(CONFIG_DIR + '\\' + filename + '_config.txt', "w")

        f.write(response.json()['output'])
        f.close()


if __name__ == '__main__':

    main()