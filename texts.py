from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
from login_required_wrapper import login_required
from sql_connection import get_connection
from twilio.twiml.messaging_response import MessagingResponse
from twillio import *

#sql cursor from sql_connection for queries
mysql = get_connection()
client, twilio_number = get_client()

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
    #reading and formatting incoming message
    body = request.values.get('Body', '')
    print(body)
    to = request.values.get('From', '')
    from_ = request.values.get('To', '')
    msg_recieved = ''.join(e for e in body if e.isalnum())
    msg_recieved = msg_recieved.strip().lower()

    # Default message is sent unless key word is found in following loop
    send_default = True

    # Choose the correct message response and set default to false
    for keyword, messages in response_messages.items():
        if keyword == msg_recieved:
            body = messages['body']
            send_default = False
            break

    if send_default:
        client.messages.create(
            body=default_message,
            from_=from_,
            to=to,
            status_callback='https://smart-goat-modern.ngrok-free.app/message-status'
        )
    else:
        client.messages.create(
            body=body,
            from_=from_,
            to=to,
            status_callback='https://smart-goat-modern.ngrok-free.app/message-status'
        )

    return body