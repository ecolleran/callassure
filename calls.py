import flask
from flask import flash, render_template, redirect, request, session, url_for, request
from twillio import *
from twilio.twiml.voice_response import VoiceResponse

client, twilio_number = get_client()

@validate_twilio_request
def user_calls_us():
    response=VoiceResponse()
    response.say("     Thank you for calling us at CallAssure to check-in today. ")
    return twiml(response)

@validate_twilio_request
def welcome():
    response = VoiceResponse()
    with response.gather(
        num_digits=1, action=url_for('menu'), method="POST"
    ) as g:
        g.say(message="      Good morning from Call Assure. We are checking-in with you for today. " +
              "Please press 1 if you are okay. " +
              "or Press 2 if you would like to contact a family member. ", loop=3)
    return twiml(response)

def menu():
    selected_option = request.form['Digits']
    option_actions = {'1': _caller_okay,
                      '2': _contact_fam}

    if selected_option in option_actions:
        response = VoiceResponse()
        option_actions[selected_option](response)
        return twiml(response)
    return _redirect_welcome()

def related_member():
    selected_option = request.form['Digits']
    option_actions = {'2': "+12063907945",
                      '3': "+12065999161",
                      "4": "+12066183566"}

    if selected_option in option_actions:
        response = VoiceResponse()
        response.dial(option_actions[selected_option])
        return twiml(response)
    return _redirect_welcome()

# private methods
def _caller_okay(response):
    response.say("Your check-in for today has been logged. ",
                 voice="Polly.Amy", language="en-GB")

    response.say("Thank you for speaking with us at Call Assure - Have " +
                 "a great day! ")

    response.hangup()
    return response

def _contact_fam(response):
    with response.gather(
        numDigits=1, action=url_for('related-member'), method="POST"
    ) as g:
        g.say("It sounds like you would like to speak to a family member. To call [name] " +
              ", press 2. To call [daughter x] , press 3. To call [son y] press 4. " +
              " To go back to the main menu press the star key.",
              voice="Polly.Amy", language="en-GB", loop=3)
    return response

def _redirect_welcome():
    response = VoiceResponse()
    response.say("Returning to the main menu", voice="Polly.Amy", language="en-GB")
    response.redirect(url_for('welcome'))

    return twiml(response)