from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
import hashlib
import MySQLdb

from sql_connection import get_connection
from schedule_verify import schedule
from utils import *

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
            cursor.execute("""INSERT INTO members(
                firstname, lastname, email, password, phonenumber, paymentplan)
                VALUES (%s, %s, %s, MD5(%s), %s, %s)""", 
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
        new_user_added(email)
    return render_template('register.html', error=error)

def new_user_added(email):
    '''series of house keeping tasks when a new user is added(user status & midnight updates)'''
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT user_id FROM members WHERE email = %s", [email])
    member_id = cursor.fetchall()
    member_id = member_id[0][0]

    cursor.execute("INSERT INTO member_status(member_id, status) VALUES (%s, %s)", [member_id, 1])
    mysql.connection.commit()
    cursor.close()

@login_required
def logout():
    session.pop('logged_in', None)
    session.pop('user_id', None)
    session.pop('firstname', None)

    flash('You were just logged out :(')
    return redirect(url_for('login'))

def middle_page():
    firstname = session['firstname']
    return render_template('middle_page.html', name=firstname)

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
            return redirect(url_for('middle_page'))
        else:
            error = 'Invalid Credentials. Please try again.'
        mysql.connection.commit()
        cursor.close()
    return render_template('login.html', error=error)

def add_remove_checkin():
    error = None
    commited = False
    data=request.json
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400

    if request.method == 'POST':
        action = data.get('action')
        user_email = data.get('user_email')
        deadline = data.get('checkin')
        days_of_week = data.get('days_of_week')
        methods = data.get('checkin_method')
        timezone_str = data.get('timezone')

        # Log received data for debugging
        print(f"Received data: {data}")
        # Validate required fields
        if not action or not user_email or not deadline or not timezone_str:
            return jsonify({'error': 'Missing required fields'}), 400
        if not days_of_week or not isinstance(days_of_week, list):
            return jsonify({'error': 'Invalid or missing days_of_week'}), 400
        if not methods or not isinstance(methods, list):
            return jsonify({'error': 'Invalid or missing checkin_method'}), 400

        cursor = mysql.connection.cursor()

        #getting user_id from email in db
        cursor.execute("SELECT user_id FROM members WHERE email = %s", [user_email])
        user_id_list = cursor.fetchall()
        if not user_id_list:
            return jsonify({'error': 'User email not found in database'}), 404
        user_id = user_id_list[0][0]

        utc_deadline, day_offset=change_to_utc(timezone_str, deadline)
        if not utc_deadline or not isinstance(day_offset, int):
            return jsonify({'error': 'Failed to convert deadline to UTC'}), 500

        try:
            if action == "add":
                for day in days_of_week:
                    day=(int(day) + day_offset - 1) % 7 + 1
                    for method in methods:
                        cursor.execute("""INSERT INTO checkin_schedule(
                            member_id, dayofweek, utc_deadline, original_timezone, method_id
                        ) VALUES (%s, %s, %s, %s, %s)""",
                        [user_id, day, utc_deadline, timezone_str, method])
                mysql.connection.commit()
                commited = True
                message='Check-ins Registered!'
            
            elif action == "remove":
                for day in days_of_week:
                    day=(int(day) + day_offset - 1) % 7 + 1
                    for method in methods:
                        cursor.execute("""DELETE FROM checkin_schedule
                            WHERE member_id = %s AND dayofweek = %s AND utc_deadline = %s AND method_id = %s""",
                            [user_id, day, utc_deadline, method])
                mysql.connection.commit()
                commited = True
                message='Check-ins Removed.'

        except MySQLdb.IntegrityError as e:
            error = 'IntegrityError: Duplicate or invalid data'
            print(f"IntegrityError: {e}")
        except MySQLdb.Error as e:
            error = 'Database Error: Invalid input or query'
            print(f"MySQLdb Error: {e}")
        except Exception as e:
            error = 'An unexpected error occurred.'
            print(f"Unexpected Error: {e}")
        finally:
            cursor.close()

        if commited:
            if action == "add":
                for day in days_of_week:
                    day = (int(day) + day_offset - 1) % 7 + 1
                    for method in methods:
                        deadline_split = utc_deadline.split(":")
                        hour = int(deadline_split[0])
                        minute = int(deadline_split[1])
                        schedule(user_id, int(day), hour, minute, int(method))
            return jsonify({'success': message}), 200
        else:
            return jsonify({'error': error or 'Failed to update check-ins'}), 500

def get_checkins():
    user_email = request.args.get('user_email')
    print(user_email)
    if not user_email:
        return jsonify({'error': 'No user email provided'}), 400

    try:
        # Query the database to get the user's existing check-in settings
        cursor = mysql.connection.cursor()

        # Fetch the check-in schedule for the user
        cursor.execute("""
            SELECT dayofweek, utc_deadline, original_timezone, method_id
            FROM checkin_schedule
            WHERE member_id = (SELECT user_id FROM members WHERE email = %s)
        """, [user_email])
        
        checkin_settings = cursor.fetchall()
        
        # If no check-in settings found, return an empty list
        if not checkin_settings:
            return jsonify({'checkin_settings': []}), 200

        # Format the response in a way that's easy to handle in the frontend
        formatted_settings = []
        for setting in checkin_settings:
            formatted_settings.append({
                'dayofweek': setting[0],
                'utc_deadline': timedelta_to_seconds(setting[1]) if isinstance(setting[1], timedelta) else setting[1].isoformat(),
                'timezone': setting[2],
                'method_id': setting[3]
            })

        return jsonify({'checkin_settings': formatted_settings}), 200

    except Exception as e:
        print(f"Error fetching settings: {e}")
        return jsonify({'error': 'An error occurred while fetching the settings'}), 500

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
        
        utc_deadline, day_offset=change_to_utc(timezone_str, deadline)

        cursor = mysql.connection.cursor()
        try:
            for day in days_of_week:
                day=(int(day) + day_offset - 1) % 7 + 1
                for method in methods:
                    cursor.execute("""INSERT INTO checkin_schedule(
                        member_id, dayofweek, utc_deadline, original_timezone, method_id
                    ) VALUES (%s, %s, %s, %s, %s)""",
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
                    deadline_split=utc_deadline.split(":")
                    hour = int(deadline_split[0])
                    minute = int(deadline_split[1])
                    schedule(user_id, int(day), hour, minute, int(method))
    return render_template('settings.html', error=error, name=firstname)