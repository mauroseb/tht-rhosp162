#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import os
import argparse
import requests

tg_token = os.getenv('TG_TOKEN')
tg_chat_id = os.getenv ('TG_CHATID')

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)


def tg_send(message, token, chat_id):
    '''Send text using the bot.'''
    full_string = 'https://api.telegram.org/bot'+ token + '/sendMessage?chat_id=' + chat_id + '&parse_mode=Markdown&text=' + message
    response = requests.get(full_string)
    return response.json()

def main():
    '''Start the bot.'''
    parser = argparse.ArgumentParser(description="Sends message on tg")
    parser.add_argument('message', metavar='M', default = 'invoked', nargs='+', help='message to send')
    args = parser.parse_args()
    test = tg_send(message=args.message[0], token=tg_token, chat_id=tg_chat_id)


if __name__ == '__main__':
    main()
