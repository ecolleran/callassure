from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
from sql_connection import get_connection
from twilio.twiml.messaging_response import MessagingResponse
from twillio import *
from utils import *
from datetime import datetime

#sql cursor from sql_connection for queries
mysql=get_connection()
client, twilio_number=get_client()
service_sid, sync_list_name=get_sync()

### RESPONSES ###
GOOD_BOY_URL = (
    "https://images.unsplash.com/photo-1518717758536-85ae29035b6d?ixlib=rb-1.2.1"
    "&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80")

@validate_twilio_request
def sms_reply():
    """Respond to incoming calls with a simple text message."""
    #start TwiML response
    resp = MessagingResponse()
    resp.message("That is great to hear. Thank you for checking in!", action='https://smart-goat-modern.ngrok-free.app/message-status', method='POST')
    return str(resp)

@validate_twilio_request
def image_reply():
    try:
        num_media = int(request.values.get("NumMedia"))
    except (ValueError, TypeError):
        return "Invalid request: invalid or missing NumMedia parameter", 400
    response = MessagingResponse()
    if not num_media:
        msg = response.message("Send us an image!")
    else:
        msg = response.message("Thanks for the image. Here's one for you!")
        msg.media(GOOD_BOY_URL)
    return str(response)

response_messages = {
    '1' : {
        'body':'That is great to hear. Enjoy your [day]!'},
    '2' : {
        'body':'Thank you for checking-in today. If you would like to have a family member contact you please let us know.'},
    '3' : {
        'body': 'Which family member would you like to speak to?'}
}
default_message = "I'm not quite sure I understand that response. If you could use some more general keywords that would help me best assist you."

@validate_twilio_request
def dynamic_sms():
    #reading incoming message values
    print("incoming message recieved.")
    print()
    body = request.values.get('Body', '')
    message_sid = request.values.get('MessageSid', None)
    to = request.values.get('From', '')
    from_ = request.values.get('To', '')

    #log incoming message into database
    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO message_logs (`to`, `from`, `body`, `message_sid`, `message_status`)
        VALUES (%s, %s, %s, %s, %s)
    """, (from_[2:], to[2:], body, message_sid, 'incoming'))
    mysql.connection.commit()
    cursor.close()

    #format message to parse for key words
    msg_recieved = ''.join(e for e in body if e.isalnum())
    msg_recieved = msg_recieved.strip().lower()

    #default message sent unless key word found
    send_default = True

    #select correct message response
    for keyword, messages in response_messages.items():
        if keyword == msg_recieved:
            body = messages['body']
            if keyword == '1':
                current_day = datetime.now().strftime('%A')
                body = body.replace('[day]', current_day)

            send_default = False
            break

    if send_default:
        response = client.messages.create(
            body=default_message,
            from_=from_,
            to=to,
            status_callback='https://smart-goat-modern.ngrok-free.app/message-status',
            messaging_service_sid='MGe6e6b3eed7d69cfda67f4b83e4b837a5'
        )
    else:
        response = client.messages.create(
            body=body,
            from_=from_,
            to=to,
            status_callback='https://smart-goat-modern.ngrok-free.app/message-status',
            messaging_service_sid='MGe6e6b3eed7d69cfda67f4b83e4b837a5'
        )
    print("sending response message...")
    print()

    #append body & id of response to sync list
    #will access later when message delivery is confirmed
    client.sync.services(service_sid).sync_lists(sync_list_name).sync_list_items.create(
        data={'message': body, 'message_sid': response.sid} )
    return body

def get_sync_list_item(message_sid):
    sync_list = client.sync.services(service_sid).sync_lists(sync_list_name).sync_list_items.list(order='desc')
    for item in sync_list:
        if item.data['message_sid'] == message_sid:
            print('retrieving response message body...')
            return item.data['message']