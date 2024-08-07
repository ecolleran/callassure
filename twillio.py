import os
from functools import wraps
import flask
from flask import Flask, request, abort, request, url_for, jsonify, current_app

from twilio.rest import Client
from twilio.request_validator import RequestValidator
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import SyncGrant

### TWILIO SETUP ###
#read secrets from docker as files
def read_secret(secret_name):
    with open(f"/run/secrets/{secret_name}", "r") as file:
        print(file.read().strip())
        return file.read().strip()

#docker
account_sid = read_secret('twilio-sid')
auth_token = read_secret('twilio-token')
api_key = read_secret('twilio-api')
api_secret = read_secret('twilio-api-secret')
service_sid = read_secret('service-sid')

#local
'''account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']
api_key = os.environ['TWILIO_API_KEY']
api_secret = os.environ['TWILIO_API_SECRET']
service_sid = os.environ['TWILIO_SERVICE_SID']'''

client = Client(account_sid, auth_token)

twilio_number='+14252509408'
sync_list_name = 'message-bodies'

def get_client():
    return client, twilio_number

def get_sync():
    return api_key, api_secret, service_sid, sync_list_name

def validate_twilio_request(f):
    """Validates that incoming requests genuinely originated from Twilio"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        validator = RequestValidator(auth_token)

        #extract original URL from X-Forwarded add headers if present
        scheme = request.headers.get('X-Forwarded-Proto', 'http') # Default to 'http' if header is absent
        host = request.headers.get('X-Forwarded-Host', request.host)
        full_url = f"{scheme}://{host}{request.path}"
        request_valid = validator.validate(
            full_url,
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

def generate_sync_token():
    sync_grant = SyncGrant(service_sid=service_sid)
    token = AccessToken(account_sid, api_key, api_secret, identity='emily-admin')
    token.add_grant(sync_grant)

    response = {
        'syncListName': sync_list_name,
        'token': token.to_jwt() }
    return jsonify(response)

def get_sync_list():
    sync_list = client.sync.services(service_sid).sync_lists(sync_list_name).fetch()

def send_text(to_text):
    message = client.messages.create(
        from_=twilio_number, 
        body="Hello from CallAssure. We haven't heard from you today today. Send us a 1 if you are okay or a 2 if you would like your family to check-in with you.", 
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