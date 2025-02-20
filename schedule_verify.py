from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
import logging
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from sql_connection import get_connection
import json
from MySQLdb.cursors import DictCursor
from calls import *
from texts import *
from utils import *

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

def schedule_from_db(day):
    times=fetch_times(day)
    cursor = mysql.connection.cursor()
    for time in times:
        total_seconds = time[0].total_seconds()
        hour = int(total_seconds // 3600)
        minute = int((total_seconds % 3600) // 60)

        query='''select member_id, method_id, utc_deadline from checkin_schedule 
            where dayofweek=%s and utc_deadline=%s order by method_id;'''
        cursor.execute(query, (day, time[0],))
        checkins = cursor.fetchall()

        for checkin in checkins: 
            member_id, method, deadline=checkin
            schedule(member_id, day, hour, minute, method)
    cursor.close()

def schedule(member_id, day, hour, minute, method):
    #format phone numebr
    cursor = mysql.connection.cursor()
    query="select phonenumber from members where user_id=%s;"
    cursor.execute(query, (member_id,))
    phonenumber = cursor.fetchall()
    phonenumber='+1'+phonenumber[0][0].replace("-", "")
    cursor.close()

    #schedule the job
    dayhrmin=str(day)+"-"+str(hour)+":"+str(minute)
    trigger = CronTrigger(day_of_week=day-1, hour=hour, minute=minute, timezone="UTC")
    job_id = f"{str(member_id)}-{dayhrmin}-{str(method)}"
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
#at scheduled time this fucntion should check if a text has been received
def confrim_checkin(member_id, phonenumber, method):
    cursor = mysql.connection.cursor()
    query="select status from member_status where member_id=%s;"
    cursor.execute(query, (member_id,))
    cursor.close()
    status = cursor.fetchall()
    if status[0][0]==1:
        if method==2:
            send_text(phonenumber)
        if method==1:
            make_call(phonenumber)
    if status[0][0]==2:
        pass
        #text family members
    if status[0][0]==3:
        pass
        #some higher level alert
    if status[0][0]==4:
        print()
        print(f'User {member_id} has already checked in today!')

def set_user_midnight():
    '''find 12:00 AM for each user based on timezone'''
    cursor = mysql.connection.cursor()
    query='''SELECT original_timezone,
        GROUP_CONCAT(DISTINCT member_id ORDER BY member_id ASC) AS member_ids
        FROM checkin_schedule GROUP BY original_timezone ORDER BY original_timezone;'''
    cursor.execute(query)
    #[x][0] is timezone, [x][1] is member_ids
    timezones = cursor.fetchall()
    cursor.close()
    for zone in timezones:
        utc_deadline, day_offset=change_to_utc(zone[0], '00:00')
        member_list=zone[1]
        deadline_split=utc_deadline.split(":")
        hour = int(deadline_split[0])
        minute = int(deadline_split[1])
        trigger = CronTrigger(hour=hour, minute=minute, timezone="UTC")
        job_id = f"{zone[0]}-midnight-reset"
        scheduler.add_job(reset_user_status, trigger, args=[member_list], id=job_id)

def reset_user_status(id_list):
    '''every day at 12:00 AM, by timezone, reset user status to not checked in'''
    id_str = ', '.join(map(str, id_list)) #format string for MySQL
    cursor = mysql.connection.cursor()
    query="update member_status set status=1 where member_id in ({id_str});"
    cursor.execute(query)
    mysql.connection.commit()
    cursor.close()

def log_sms_staus():
    if request.method == 'POST':
        from_ = request.values.get('From', '')
        from_=from_[2:]
        to = request.values.get('To', '')
        to=to[2:]
        message_sid = request.values.get('MessageSid', None)
        message_status = request.values.get('MessageStatus', None)

        if message_status == "delivered":
            body=get_sync_list_item(message_sid)
            cursor = mysql.connection.cursor()
            cursor.execute("""
                INSERT INTO message_logs (`to`, `from`, `body`, `message_sid`, `message_status`)
                VALUES (%s, %s, %s, %s, %s)
                """, (to, from_, body, message_sid, message_status))
            mysql.connection.commit()
            cursor.close()
            print("response message logged")
        return ('Status logged', 200)
    
    if request.method == 'GET':
        cursor = mysql.connection.cursor(DictCursor)
        cursor.execute("SELECT * FROM message_logs ORDER BY id DESC")
        logs = cursor.fetchall()
        cursor.close()
        return render_template('message_status.html', logs=logs)

def get_message_logs():
# Get the user_email from the request parameters
    user_email = request.args.get('user_email')
    if not user_email:
        return jsonify({'error': 'No user email provided'}), 400
    try: 
        cursor = mysql.connection.cursor()        
        cursor.execute("""SELECT phonenumber FROM members WHERE email = %s""", (user_email,))
        user = cursor.fetchall()

        # If no phone number is found, return an error
        if not user:
            return jsonify({'error': 'No user found with the given email'}), 404

        user_phone = user[0][0]
        user_phone = user_phone.replace('-', '')
        cursor = mysql.connection.cursor(DictCursor)
        # Fetch the message logs where the user's phone number is in "to" or "from"
        cursor.execute("""SELECT * FROM message_logs WHERE `to` = %s OR `from` = %s ORDER BY timestamp DESC""", (user_phone, user_phone))
            
        logs = cursor.fetchall()

        # Close the database connection
        cursor.close()

        # Format and return the logs
        return jsonify({'message_logs': logs}), 200
    except Exception as e:
        print(f"Error fetching message logs: {e}")
        return jsonify({'error': 'An error occurred while fetching the message logs'}), 500

def confirm_sms():
    # unique_id = request.values.get('id', None)
    # Use a unique id associated with your user to figure out the Message Sid
    message_sid = 'SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

    client.messages(message_sid).feedback.create(outcome="confirmed")

    return ('Thank you!', 200)