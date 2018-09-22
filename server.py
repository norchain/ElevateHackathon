from flask import Flask
from flask_pymongo import PyMongo
import json


app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/Elevate"
mongo = PyMongo(app)


@app.route("/review", methods=['POST', 'GET'])
def review():
    try:
        if request.method == 'POST':
            data = request.get_json()
            mongo.db.review.insert({"client_id": data['client_id'], "td_account": data['td_account'], "stars": data['start'], "comment": data['comment']})
            return {}, 200
        if request.method == 'GET':
            total = []
            for one in mongo.db.review.find({}, {"_id": False}):
                print(one)
                total.append(one)
            return json.dumps(total), 200
    except Exception as error:
        print(error)
        return {}, 400

@app.route("/restaurants", methods=['GET'])
def restaurants():
    try:
        total = []
        for one in mongo.db.restaurants.find({}, {"_id": False}):
            total.append(one)
        return json.dumps(total), 200
    except Exception as error:
        print(error)
        return {}, 400
