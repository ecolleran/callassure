import os
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import SyncGrant
from flask import Flask, jsonify, request, render_template
from twilio.twiml.messaging_response import MessagingResponse
from twilio.rest import Client
from twillio import *

account_sid = send_sid()
api_key = os.environ.get('TWILIO_API_KEY')
api_secret = os.environ.get('TWILIO_API_SECRET')
service_sid = os.environ.get('TWILIO_SYNC_SERVICE_SID', 'default')
sync_list_name = os.environ.get('SYNC_LIST_NAME', 'serverless-sync-demo')

client, twilio_number = get_client()

def generate_sync_token():
    sync_grant = SyncGrant(service_sid=service_sid)
    token = AccessToken(account_sid, api_key, api_secret, identity='example')
    token.add_grant(sync_grant)

    response = {
        'syncListName': sync_list_name,
        'token': token.to_jwt()
    }
    return jsonify(response)

def handle_sms():
    incoming_message = request.form['Body']
    response = MessagingResponse()

    try:
        # Ensure that the Sync List exists before adding a new message to it
        get_or_create_sync_list(service_sid, sync_list_name)

        # Append the incoming message to the Sync List
        client.sync.services(service_sid).sync_lists(sync_list_name).sync_list_items.create(
            data={'message': incoming_message}
        )

        # Send a response back to the user to let them know the message was received
        response.message('SMS received and added to the list! 🚀')
    except Exception as e:
        # Log the error for debugging
        print(f"Error: {e}")

        # Send a response back to the user to let them know something went wrong
        response.message('Something went wrong with adding your message 😔')

    return str(response)

def get_or_create_sync_list(service_sid, list_name):
    try:
        # Check if the Sync List exists
        client.sync.services(service_sid).sync_lists(list_name).fetch()
    except:
        # If it does not exist, create it
        client.sync.services(service_sid).sync_lists.create(unique_name=list_name)

def sync_page():
    return render_template('sync.html')