from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
import logging
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from login_required_wrapper import login_required
from sql_connection import get_connection
from twilio.twiml.messaging_response import MessagingResponse
from twillio import *
import json
from MySQLdb.cursors import DictCursor
from datetime import datetime
import uuid
from calls import *

### SCEDULER & LOGGING ###
#logging.basicConfig(level=logging.DEBUG)
logging.basicConfig(level=logging.INFO)
scheduler = BackgroundScheduler()

mysql = get_connection()

### SCHEDULE ###
def fetch_times(day):
    cursor = mysql.connection.cursor()
    
    query= "select distinct utc_deadline from checkin_schedule where dayofweek=%s;"
    cursor.execute(query, (day,))
    times = cursor.fetchall()
    
    cursor.close()
    return times

def schedule_checkins(day):
    times=fetch_times(day)
    
    cursor = mysql.connection.cursor()
    for time in times:
        total_seconds = time[0].total_seconds()
        hour = int(total_seconds // 3600)
        minute = int((total_seconds % 3600) // 60)
        dayhrmin=str(day)+"-"+str(hour)+":"+str(minute)

        query="select member_id, method_id, utc_deadline from checkin_schedule where dayofweek=%s and utc_deadline=%s order by method_id;"
        cursor.execute(query, (day, time[0],))
        checkins = cursor.fetchall()

        for checkin in checkins: 
            member, method, deadline=checkin
            query="select phonenumber from members where user_id=%s;"
            cursor.execute(query, (member,))
            phonenumber = cursor.fetchall()
            phonenumber='+1'+phonenumber[0][0].replace("-", "")

            # Schedule the job
            trigger = CronTrigger(day_of_week=day-1, hour=hour, minute=minute, timezone="UTC")
            job_id = f"{str(member)}-{dayhrmin}-{str(method)}"
            if method==2:
                scheduler.add_job(send_text, trigger, args=[phonenumber], id=job_id)
            if method=='1':
                scheduler.add_job(make_call, trigger, args=[phonenumber], id=job_id)
    cursor.close()

def add_new_job(user_id, day, deadline, method):
    deadline_split=deadline.split(":")
    hour = int(deadline_split[0])
    minute = int(deadline_split[1])
    dayhrmin=str(day)+"-"+str(hour)+":"+str(minute)

    cursor = mysql.connection.cursor()
    query="select phonenumber from members where user_id=%s;"
    cursor.execute(query, (user_id,))
    phonenumber = cursor.fetchall()
    phonenumber='+1'+phonenumber[0][0].replace("-", "")
    cursor.close()

    # Schedule the job
    trigger = CronTrigger(day_of_week=day-1, hour=hour, minute=minute, timezone="UTC")
    job_id = f"{str(user_id)}-{dayhrmin}-{str(method)}"
    if method==2:
        scheduler.add_job(send_text, trigger, args=[phonenumber], id=job_id)
    if method==1:
        scheduler.add_job(make_call, trigger, args=[phonenumber], id=job_id)

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
    return render_template('jobs.html', jobs=job_list)

### VERIFY & LOG ###
'''#at scheduled time this fucntion should check if a text has been received
def confrim_checkin():
    cursor = mysql.connection.cursor()
    query=""
    cursor.execute(query, (user_id,))
    cursor.close()'''


def log_sms_staus():
    if request.method == 'POST':
        body = request.values.get('Body', '')
        print(body)
        from_ = request.values.get('From', '')
        from_=from_[2:]
        to = request.values.get('To', '')
        to=to[2:]
        message_sid = request.values.get('MessageSid', None)
        message_status = request.values.get('MessageStatus', None)

        if message_status=="delivered":
            cursor = mysql.connection.cursor()
            cursor.execute("""
                INSERT INTO message_logs (`to`, `from`, `body`, `message_sid`, `message_status`)
                VALUES (%s, %s, %s, %s, %s)
            """, (to, from_, body, message_sid, message_status))
            mysql.connection.commit()
            cursor.close()

        return ('Status logged', 200)
    
    if request.method == 'GET':
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