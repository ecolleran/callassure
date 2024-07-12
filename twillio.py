#!/usr/bin/env python3
import requests
import schedule
import time
import os

from twilio.rest import Client

### TWILIO SETUP ###
#docker
account_sid = os.getenv('TWILIO_ACCOUNT_SID')
auth_token = os.getenv('TWILIO_AUTH_TOKEN')

#local
'''account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']'''

client = Client(account_sid, auth_token)


def send_text(to_text):
    message = client.messages.create(
        from_='+14252509408', 
        body='Hello from CallAssure. We are checking in with you for today.', 
        status_callback='https://smart-goat-modern.ngrok-free.app/message-status',
        provide_feedback=True,
        messaging_service_sid='MGe6e6b3eed7d69cfda67f4b83e4b837a5',
        to=to_text)
    print(f'Message sent, SID:{message.sid}')

def make_call(to_call):
    call = client.calls.create(
        url='http://demo.twilio.com/docs/voice.xml',
        to=to_call,
        from_='whatsapp:+14155238886')
    print(call.sid)

def retrieve_message(sid):
    message = client.messages(sid).fetch()
    print(message.to)

def retrieve_message_multi(limit=20):
    messages = client.messages.list(limit=limit)
    '''date_sent=datetime(2016, 8, 31, 0, 0, 0),
    from_='+15017122661',
    to='+15558675310',
    limit=20'''

    for record in messages:
        print(record.sid)

def hi():
    print("hi")

def main():
    print("hi")
    time_at="14:39"
    schedule.every().day.at(time_at, "America/Los_Angeles").do(send_text)
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == '__main__':
    main()