#!/usr/bin/env python3
import requests
import schedule
import time
import os

from functools import wraps
from twilio.rest import Client
from twilio.request_validator import RequestValidator
from flask import Flask, request, abort, request, url_for, jsonify, current_app

### TWILIO SETUP ###
#read secrets from docker as files
def read_secret(secret_name):
    with open(f"/run/secrets/{secret_name}", "r") as file:
        return file.read().strip()

#docker
account_sid = read_secret('twilio-sid')
auth_token = read_secret('twilio-token')

#local
'''account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']'''

client = Client(account_sid, auth_token)
twilio_number='+14252509408'

def get_client():
    return client, twilio_number

def validate_twilio_request(f):
    """Validates that incoming requests genuinely originated from Twilio"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        #instance RequestValidator class
        validator = RequestValidator(auth_token)

        # Validate the request using its URL, POST data,
        # and X-TWILIO-SIGNATURE header
        request_valid = validator.validate(
            request.url,
            request.form,
            request.headers.get('X-TWILIO-SIGNATURE', ''))

        #continue processing if request is valid else return a 403 error if
        if request_valid or current_app.debug:
            return f(*args, **kwargs)
        else:
            return abort(403)
    return decorated_function

def twiml(resp):
    resp = flask.Response(str(resp))
    resp.headers['Content-Type'] = 'text/xml'
    return resp

def send_text(to_text):
    message = client.messages.create(
        from_=twilio_number, 
        body='Hello from CallAssure. We are checking in with you for today. Send us a 1 if you are okay or a 2 if you would like your family to check-in with you.', 
        status_callback='https://smart-goat-modern.ngrok-free.app/message-status',
        provide_feedback=True,
        messaging_service_sid='MGe6e6b3eed7d69cfda67f4b83e4b837a5',
        to=to_text)
    print()
    print(f'Message sent to {to_text}, SID:{message.sid}')

def make_call(to_call):
    call = client.calls.create(
        url='https://smart-goat-modern.ngrok-free.app/call/welcome',
        to=to_call,
        from_=twilio_number)
    print(f'Message sent to {to_call}, SID:{call.sid}')

def retrieve_message(sid):
    message = client.messages(sid).fetch()
    print(message.to)

def retrieve_message_multi(limit=20):
    messages = client.messages.list(limit=limit)
    '''date_sent=datetime(2016, 8, 31, 0, 0, 0),
    from_=twilio_number,
    to='+15558675310',
    limit=20'''

    for record in messages:
        print(record.sid)