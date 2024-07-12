from flask import Flask, render_template, request, session, redirect, url_for, flash, jsonify
from login_required_wrapper import login_required
import hashlib
from sql_connection import get_connection
import MySQLdb

#sql cursor from sql_connection for queries
mysql = get_connection()

def hello():
  return "Welcome to CallAssure ~we're still under construction~!"

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

        # try to insert into database (throws error if username already exists)
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
    session.pop('username', None)
    session.pop('first_name', None)
    session.pop('id', None)
    session.pop('search_mode', None)

    flash('You were just logged out :(')
    return redirect(url_for('login'))

def login():
    error = None
    if request.method == 'POST':
        # username and password from form
        email = request.form['email']
        password = request.form['password']

        # get password from database
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT password FROM members WHERE email = %s", [email])
        dbPass = cursor.fetchall()

        # check passwords
        hashpass = hashlib.md5(password.encode('utf-8')).hexdigest()
        # if passwords match
        if hashpass == dbPass[0][0]:
            # get more info
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
    error=None
    user_id = session['user_id']
    firstname = session['firstname']
    if request.method== 'POST':
        checkin_time=request.form['checkin']
        days_of_week = request.form.getlist('days')
        methods = request.form.getlist('checkin_method')
        
        cursor = mysql.connection.cursor()
        try:
            for day in days_of_week:
                for method in methods:
                    cursor.execute("""
                    INSERT INTO checkin_schedule(
                        member_id, dayofweek, deadline, method_id
                    ) VALUES (
                        %s, %s, %s, %s
                    )""",
                    [user_id, day, checkin_time, method])
            mysql.connection.commit()
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

        # close connection
        mysql.connection.commit()
        cursor.close()
    return render_template('settings.html', error=error, name=firstname)