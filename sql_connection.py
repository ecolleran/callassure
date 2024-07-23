from flask import Flask
from flask_mysqldb import MySQL
import os

### FLASK SETUP ###
app = Flask(__name__)
app.secret_key='02ebaba3ce6e6cf74edb27a1c0e355b19199a81f0e6e8801c560d7ae4d9c4f6e'

### SQL SETUP ###
#docker
app.config['MYSQL_HOST'] = 'db'
app.config['MYSQL_USER'] = 'mysql'
app.config['MYSQL_PASSWORD'] = os.getenv('SQL_PASS')

#local
'''app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = os.environ['SQL_PASS']'''

app.config['MYSQL_DB'] = 'callassure'
mysql = MySQL(app)

### FUNCTIONS ###
def get_connection():
    return mysql

def get_app():
    return app

