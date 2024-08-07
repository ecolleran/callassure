from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
from login_required_wrapper import login_required
import hashlib
from sql_connection import get_connection
from schedule_verify import schedule
import MySQLdb

import pytz
from datetime import datetime

#sql cursor from sql_connection for queries
mysql = get_connection()

def hello():
  return render_template('welcome.html')

def register():
    error = None
    if request.method == 'POST':
        # get info from user
        firstname = request.form['first_name']
        lastname  = request.form['last_name']
        email = request.form['email']
        password   = request.form['password']
        phonenumber = request.form['phonenumber']
        #payment_plan = request.form['payment_plan']

        # try to insert into database (throws errors as needed)
        cursor = mysql.connection.cursor()
        try:
            cursor.execute("""
            INSERT INTO members(
                firstname, lastname, email, password, phonenumber, paymentplan
                ) VALUES (
                    %s, %s, %s, MD5(%s), %s, %s
                )""", 
                [firstname, lastname, email, password, phonenumber, 1])
            flash('Account created!')
            return redirect(url_for('login'))
        except MySQLdb.IntegrityError as e:
            error = 'Account already in use. Please use another name'
            print(f"IntegrityError: {e}")
        except MySQLdb.Error as e:
            error = 'Username or password too long. Please try again.'
            print(f"MySQLdb Error: {e}")
        except Exception as e:
            error = 'An unexpected error occurred. Please try again.'
            print(f"Unexpected Error: {e}")

        # close connection
        mysql.connection.commit()
        cursor.close()
    return render_template('register.html', error=error)

@login_required
def logout():
    session.pop('logged_in', None)
    session.pop('user_id', None)
    session.pop('firstname', None)

    flash('You were just logged out :(')
    return redirect(url_for('login'))

def login():
    error = None
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        #get password from database
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT password FROM members WHERE email = %s", [email])
        dbPass = cursor.fetchall()

        # check passwords
        hashpass = hashlib.md5(password.encode('utf-8')).hexdigest()
        if hashpass == dbPass[0][0]:
            #get more info
            cursor.execute("SELECT firstname, user_id FROM members WHERE email = %s", [email])
            vals = cursor.fetchall()
            name = vals[0][0]
            user_id = vals[0][1]

            #update session info
            session['logged_in'] = True
            session['user_id'] = user_id
            session['firstname'] = name
            flash('You were just logged in!')
            return redirect(url_for('settings'))
        else:
            error = 'Invalid Credentials. Please try again.'
        mysql.connection.commit()
        cursor.close()
    return render_template('login.html', error=error)

@login_required
def settings():
    error = None
    commited = False
    user_id = session['user_id']
    firstname = session['firstname']
    
    if request.method == 'POST':
        deadline = request.form['checkin']
        days_of_week = request.form.getlist('days')
        methods = request.form.getlist('checkin_method')
        timezone_str = request.form['timezone']
        
        #get current date to change tz
        today = datetime.now().date()
        local_time_str = f"{today} {deadline}"
        local_time = datetime.strptime(local_time_str, '%Y-%m-%d %H:%M')
        
        #convert deadline to UTC
        local_tz = pytz.timezone(timezone_str)
        local_time = local_tz.localize(local_time)
        utc_time = local_time.astimezone(pytz.utc)
        utc_deadline = utc_time.strftime('%H:%M:%S') #format for MySQL
        
        #check if the day changes after converting to UTC
        day_offset = 0
        if utc_time.date() > local_time.date():
            day_offset = 1

        cursor = mysql.connection.cursor()
        try:
            for day in days_of_week:
                day=(int(day) + day_offset - 1) % 7 + 1
                for method in methods:
                    cursor.execute("""
                    INSERT INTO checkin_schedule(
                        member_id, dayofweek, utc_deadline, original_timezone, method_id
                    ) VALUES (
                        %s, %s, %s, %s, %s
                    )""",
                    [user_id, day, utc_deadline, timezone_str, method])
            mysql.connection.commit()
            commited = True
            flash('Check-ins Registered!')

        except MySQLdb.IntegrityError as e:
            error = 'Username already in use. Please use another username'
            print(f"IntegrityError: {e}")
        except MySQLdb.Error as e:
            error = 'Username or password too long. Please try again.'
            print(f"MySQLdb Error: {e}")
        except Exception as e:
            error = 'An unexpected error occurred. Please try again.'
            print(f"Unexpected Error: {e}")
        cursor.close()

        if commited:
            for day in days_of_week:
                day=(int(day) + day_offset - 1) % 7 + 1
                for method in methods:
                    deadline_split=deadline.split(":")
                    hour = int(deadline_split[0])
                    minute = int(deadline_split[1])
                    schedule(user_id, int(day), hour, minute, int(method))
    return render_template('settings.html', error=error, name=firstname)