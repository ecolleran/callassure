from flask import Flask, session, redirect, url_for, flash, abort, request
from functools import wraps
from datetime import datetime
import pytz
import os

from twilio.request_validator import RequestValidator

environment = os.getenv('FLASK_ENV', 'local')  #default to 'local' if not set
def read_secret(secret_name):
    with open(f"/run/secrets/{secret_name}", "r") as file:
        return file.read().strip()

if environment == 'docker':
    auth_token = read_secret('twilio-token')
else: 
    auth_token = os.environ['TWILIO_AUTH_TOKEN']

#wrapper to require a login for some pages
def login_required(f):
    @wraps(f)
    def wrap(*args, **kwds):
        if 'logged_in' in session:
            return f(*args, **kwds)
        else:
            flash('You need to login first')
            return redirect(url_for('login'))
    return wrap

def validate_twilio_request(f):
    """Validates that incoming requests genuinely originated from Twilio"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        validator = RequestValidator(auth_token)

        #extract original URL from X-Forwarded-* headers if present
        scheme = request.headers.get('X-Forwarded-Proto', 'http') # Default to 'http' if header is absent
        host = request.headers.get('X-Forwarded-Host', request.host)
        full_url = f"{scheme}://{host}{request.path}"
        request_valid = validator.validate(
            full_url,
            request.form,
            request.headers.get('X-TWILIO-SIGNATURE', ''))

        #continue processing if request is valid else return a 403 error if
        if request_valid:
            return f(*args, **kwargs)
        else:
            print("verification issue. aborting message delivery")
            return abort(403)
    return decorated_function

def read_secret(secret_name):
    with open(f"/run/secrets/{secret_name}", "r") as file:
        return file.read().strip()

def twiml(resp):
    resp = flask.Response(str(resp))
    resp.headers['Content-Type'] = 'text/xml'
    return resp

def change_to_utc(timezone, timestamp):
    #get current date to change tz
    today = datetime.now().date()
    local_time_str = f"{today} {timestamp}"
    local_time = datetime.strptime(local_time_str, '%Y-%m-%d %H:%M')
        
    #convert deadline to UTC
    local_tz = pytz.timezone(timezone)
    local_time = local_tz.localize(local_time)
    utc_time = local_time.astimezone(pytz.utc)
    utc_deadline = utc_time.strftime('%H:%M:%S') #format for MySQL
        
    #check if the day changes after converting to UTC
    day_offset = 0
    if utc_time.date() > local_time.date():
        day_offset = 1

    return utc_deadline, day_offset