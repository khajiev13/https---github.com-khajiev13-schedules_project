from crypt import methods
from flask import Flask, render_template, request
import mysql.connector


# Connect to SQL server
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="7191710r",
    database="activities_schedule",
    autocommit=True
)

my_cursor = mydb.cursor()
my_cursor.execute("SELECT * FROM locations")


str = ''
for x in my_cursor:
    str += "{}".format(x[0])

print(str)

app = Flask(__name__)
app.run(debug=True)


@app.route("/", methods=["GET", "POST"])
def index():
    name = request.args.get("name")
    return render_template("index.html", name=name)


@app.route("/greet")
def greet():
    name = request.args.get("name", "world")
    return render_template("greet.html", name=name)


@app.route("/locations", methods=["GET", "POST"])
def locations():
    return render_template("locations.html")


@app.route("/location_registered", methods=["GET"])
def location_registered():
    loc_name = request.args.get("loc_name")
    located_campus = request.args.get("located_campus")
    my_cursor.execute("USE activities_schedule")
    my_cursor.execute('''INSERT INTO locations(loc_name, located_campus) VALUES("{}", "{}")'''.format(
        loc_name, located_campus))
    str = ''
    my_cursor.execute("SELECT * FROM locations")
    for x in my_cursor:
        str += "{}".format(x[0])
    print(str)
    return "You have succesfully inserted {}".format(str)
