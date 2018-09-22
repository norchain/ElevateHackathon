from flask import Flask
from flask_pymongo import PyMongo


app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/Elevate"
mongo = PyMongo(app)


@app.route("/review", methods=['POST', 'GET'])
def review():
    if request.method == 'POST':
        data = request.get_json()
        mongo.db.review.insert({"client_id": data['client_id'], "td_account": data['td_account'], "stars": data['start'], "comment": data['comment']})
        return {}, 200
    if request.method == 'GET':
        total = mongo.db.review.find()
        return total, 200

@app.route("/restaurants", methods=['GET'])
def restaurants():
    try:
        return mongo.db.restaurants.find(), 200
    except error:
        print(error)
        return {}, 400
