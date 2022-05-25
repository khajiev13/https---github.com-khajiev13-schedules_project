from crypt import methods
from platform import python_branch
from flask import Flask, render_template, request
import mysql.connector
# from 'python_codes/objects.py' import *

# Connect to SQL server
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="7191710r",
    database="activities_schedule",
    autocommit=True
)

my_cursor = mydb.cursor()


# my_cursor.execute("SELECT * FROM locations")
# str = ''
# for x in my_cursor:
#     str += "{}".format(x)

# print("Hello world", str)

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
def add_locations():
    sport_types = set()
    my_cursor.execute("SELECT type FROM activity_types ORDER BY type")
    for row in my_cursor:
        row = str(row)[2:-3]
        sport_types.add(row)
    return render_template("locations.html", sport_types=sport_types)


@app.route("/location_registered", methods=["GET"])
def location_registered():
    loc_name = request.args.get("loc_name")
    located_campus = request.args.get("located_campus")
    sport_types = request.args.getlist("sport-types")
    for sport_type in sport_types:
        my_cursor.execute(
            f"""CALL add_location('{loc_name}','{located_campus}','{sport_type}') """)
    return "You have succesfully inserted {}".format(loc_name)


@app.route("/students")
def add_students():
    return render_template("students.html")


@app.route("/student_registered")
def student_registered():
    student_id = request.args.get("student_id")
    first_name = request.args.get("first_name")
    last_name = request.args.get("last_name")
    nickname = request.args.get("nickname")
    birthday = request.args.get("birthday")
    degree = request.args.get("degree")
    school_year = request.args.get("school_year")
    major = request.args.get("major")
    player_id = request.args.get("player_id")
    my_cursor.execute(f'''INSERT INTO students (first_name,last_name,nickname,birth,school_year,major,regist_date,degree,team_id,player_id,school_student_id)
                          VALUES('{first_name}','{last_name}','{nickname}',
                          '{birthday}','{school_year}','{major}',NOW(),'{degree}',NULL,'{player_id}',
                          '{student_id}')''')
    return f'''{student_id},{first_name},{last_name},{nickname},{birthday},
    {degree},{school_year},{major},{player_id}'''


@app.route("/activities")
def add_activities():
    return render_template("activities.html")


@app.route("/activity_registered")
def activity_type_register():
    type = request.args.get("type")
    part_num = request.args.get("max_num_participants")
    my_cursor.execute(f'''INSERT INTO activity_types (type, max_num_participants)
                            VALUES('{type}',{part_num})''')
    my_cursor.execute(f"SELECT * FROM activity_types WHERE type = '{type}' ")
    added_element = list()
    for item in my_cursor:
        added_element.append(item[1])
    return f"{added_element} has been added"


@app.route("/schedules")
def add_schedules():
    sport_types = set()
    my_cursor.execute("SELECT type FROM activity_types ORDER BY type")
    for row in my_cursor:
        row = str(row)[2:-3]  # Get rid of ( and ' from the list
        sport_types.add(row)  # Add it to a new set

    referees = set()
    my_cursor.execute(
        "SELECT CONCAT(first_name,' ',last_name) FROM activities_schedule.referees ORDER BY first_name;")
    for row in my_cursor:
        row = str(row)[2:-3]  # Get rid of ( and ' from the list
        referees.add(row)

    locations = set()
    my_cursor.execute("SELECT loc_name, located_campus FROM locations")
    for row in my_cursor:
        row1 = str(row[0]).strip("(),'")  # Get rid of ( and ' from the list
        row2 = row[1].strip("(),'")
        row = row1 + " ( " + row2 + " )"
        locations.add(row)

    return render_template("schedules.html", sport_types=sport_types, referees=referees, locations=locations)


@ app.route("/schedule_registered")
def schedule_register():
    type_name = request.args.get("activity_type_name")
    datetime = request.args.get("datetime")
    location_name = request.args.get("location_name")


@ app.route("/teams")
def add_teams():
    return render_template("teams.html")


@ app.route("/team_registered")
def team_registered():
    type = request.args.get("type")
    team_name = request.args.get("team_name")
    uniform_color = request.args.get("uniform_color")
    captain_name = request.args.get("captain_name")
    return "Under maintenance"


@ app.route("/referees")
def add_referees():
    sport_types = set()
    my_cursor.execute("SELECT type FROM activity_types ORDER BY type")
    for row in my_cursor:
        row = str(row)[2: -3]
        sport_types.add(row)
    return render_template("referees.html", sport_types=sport_types)


@ app.route("/referee_registered")
def referee_registered():
    type = request.args.get("type")
    first_name = request.args.get("first_name")
    last_name = request.args.get("last_name")
    experience = request.args.get("experience")
    uniform_color = request.args.get("uniform_color")
    my_cursor.execute(
        f"""SELECT `activity_type_id` FROM `activity_types` WHERE `type` = '{type}'""")
    type_id = None
    for row in my_cursor:
        type_id = row[0]
    my_cursor.execute(f'''INSERT INTO `referees` (`activity_type_id`, `first_name`, `last_name`, `experience_year`, `uniform_color`)
                        VALUES ('{type_id}', '{first_name}', '{last_name}', '{experience}', '{uniform_color}');''')

    return f""""{first_name} {last_name} has been registered succesfully!"""
