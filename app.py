from flask import Flask, render_template, url_for, request
from twilio.twiml.messaging_response import MessagingResponse

### import from other files ###
from account_settings import *
from phone_calls import *
from schedule_verify import *
#from schedule_verify import scheduler, schedule_checkins
from sql_connection import get_app
from texts import *
from twillio import *
from datetime import datetime

#get app from sql_connection
app = get_app()

### URLs ###
app.add_url_rule('/', view_func=hello)
app.add_url_rule('/register', methods=['GET','POST'], view_func=register)
app.add_url_rule('/settings', methods=['GET','POST'], view_func=settings)
app.add_url_rule('/login', methods=['GET','POST'], view_func=login)
app.add_url_rule('/logout', view_func=logout)
app.add_url_rule('/message-status', methods=['GET','POST'], view_func=log_sms_staus)
app.add_url_rule('/confirm', methods=['GET'], view_func=confirm_sms)
app.add_url_rule('/jobs', methods=['GET'], view_func=show_jobs)
app.add_url_rule('/sms', methods=['GET', 'POST'], view_func=sms_reply)
app.add_url_rule('/image', methods=['GET', 'POST'], view_func=image_reply)
app.add_url_rule('/dynamic-sms', methods=['GET', 'POST'], view_func=incoming_sms)


# scheduler
with app.app_context():
  scheduler.start()
  scheduler.remove_all_jobs()
  #today=datetime.now().isoweekday()
  for day in range(7):
    schedule_checkins(day)

### MAIN ###
if __name__ == "__main__":
  try:
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=8000)
  except (KeyboardInterrupt, SystemExit):
    scheduler.shutdown()