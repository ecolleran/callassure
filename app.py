from flask import Flask, render_template, url_for, request
from twilio.twiml.messaging_response import MessagingResponse

### import from other files ###
from account_settings import *
from calls import *
from schedule_verify import *
from sql_connection import get_app
from texts import *
from twillio import *

from datetime import datetime

#get app from sql_connection
app = get_app()

### URLs ###
#UI & account urls
app.add_url_rule('/', view_func=hello)
app.add_url_rule('/register', methods=['GET','POST'], view_func=register)
app.add_url_rule('/settings', methods=['GET','POST'], view_func=settings)
app.add_url_rule('/login', methods=['GET','POST'], view_func=login)
app.add_url_rule('/logout', view_func=logout)

#scheduling & tracking
app.add_url_rule('/message-status', methods=['GET','POST'], view_func=log_sms_staus)
app.add_url_rule('/confirm', methods=['GET'], view_func=confirm_sms)
app.add_url_rule('/jobs', methods=['GET'], view_func=show_jobs)
#sync
app.add_url_rule('/generate-sync-token', methods=['GET'], view_func=generate_sync_token)

#text responses
app.add_url_rule('/sms', methods=['GET', 'POST'], view_func=dynamic_sms)
app.add_url_rule('/image', methods=['GET', 'POST'], view_func=image_reply)

#phone call roadmap urls
app.add_url_rule('/called', methods=['GET', 'POST'], view_func=user_calls_us)
app.add_url_rule('/call/welcome', methods=['POST'], view_func=welcome)
app.add_url_rule('/call/menu', methods=['POST'], view_func=menu)
app.add_url_rule('/call/related-member', methods=['POST'], view_func=related_member)


# scheduler
with app.app_context():
  scheduler.start()
  for day in range(1, 8):
    schedule_from_db(day)

### MAIN ###
if __name__ == "__main__":
  try:
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=8000)
  except (KeyboardInterrupt, SystemExit):
    scheduler.shutdown()