from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
import logging
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from login_required_wrapper import login_required
from sql_connection import get_connection
from twilio.twiml.messaging_response import MessagingResponse
from twillio import *
from datetime import datetime
import json
from MySQLdb.cursors import DictCursor
import uuid

### SCEDULER & LOGGING ###
#logging.basicConfig(level=logging.DEBUG)
logging.basicConfig(level=logging.INFO)
scheduler = BackgroundScheduler()

#sql cursor from sql_connection for queries
mysql = get_connection()

### SCHEDULE ###
def fetch_times(today):
    cursor = mysql.connection.cursor()
    
    query= "select distinct deadline from checkin_schedule where dayofweek=%s;"
    cursor.execute(query, (today,))
    times = cursor.fetchall()
    
    cursor.close()
    #print(times) #this is a set with an int val in each entry. [x][0] is a time
    return times

def schedule_checkins():
    #scheduler.remove_all_jobs()
    scheduler.start()
    today=datetime.now().isoweekday()
    times=fetch_times(today)
    
    cursor = mysql.connection.cursor()
    for time in times:
        total_seconds = time[0].total_seconds()
        hour = int(total_seconds // 3600)
        minute = int((total_seconds % 3600) // 60)
        dayhrmin=str(today)+str(hour)+str(minute)

        query="select member_id, method_id, deadline from checkin_schedule where dayofweek=%s and deadline=%s order by method_id;"
        cursor.execute(query, (today, time[0],))
        checkins = cursor.fetchall()

        for checkin in checkins: 
            member, method, deadline=checkin
            query="select firstname, phonenumber from members where user_id=%s;"
            cursor.execute(query, (member,))
            result = cursor.fetchall()
            name = result[0][0]
            phonenumber = result [0][1]
            phonenumber='+1'+phonenumber[0][0].replace("-", "")

            # Schedule the job
            trigger = CronTrigger(day_of_week=today-1, hour=hour, minute=minute)
            #job_id=str(member)+dayhrmin+name
            job_id = f"{member}-{dayhrmin}-{name}-{str(uuid.uuid4())}"
            scheduler.add_job(send_text, trigger, args=[phonenumber], id=job_id)
    cursor.close()

def show_jobs():
    jobs=scheduler.get_jobs()
    job_list=[]
    for job in jobs:
        job_info = {
            'id': job.id,
            'name': job.name,
            'trigger': str(job.trigger),
            'next_run_time': str(job.next_run_time)
        }
        job_list.append(job_info)
    return (jsonify(job_list), 200)

### VERIFY & LOG ###
def log_sms_staus():
    if request.method == 'POST':
        message_sid = request.values.get('MessageSid', None)
        message_status = request.values.get('MessageStatus', None)

        cursor = mysql.connection.cursor()
        cursor.execute("""
            INSERT INTO message_logs (message_sid, message_status)
            VALUES (%s, %s)
        """, (message_sid, message_status))
        mysql.connection.commit()
        cursor.close()

        return ('Status logged', 200)
    
    #GET request, fetch and display logs
    cursor = mysql.connection.cursor(DictCursor)
    cursor.execute("SELECT * FROM message_logs ORDER BY id DESC")
    logs = cursor.fetchall()
    cursor.close()
    return render_template('message_status.html', logs=logs)

def confirm_sms():
    # unique_id = request.values.get('id', None)
    # Use a unique id associated with your user to figure out the Message Sid
    message_sid = 'SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

    client.messages(message_sid).feedback.create(outcome="confirmed")

    return ('Thank you!', 200)