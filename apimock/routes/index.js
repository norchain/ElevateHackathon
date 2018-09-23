var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/Elevate');
const restaurantModel = mongoose.model('restaurants', { name: String,
    description: String,
    price: String,
	TD_account: String,
	rate: Number,
	total: Number
});

const reviewModel = mongoose.model('review', {
    client_id: String,
    td_account: String,
    stars: String,
	comment: String,
});

/* GET home page. */
router.get('/*', function(req, res, next) {
    res.header('Access-Control-Allow-Origin', "*" );
    next();
});

// global controller
router.post('/*',function(req,res,next){
    res.header('Access-Control-Allow-Origin', "*" );
    next();
});

router.get('/restaurants', function(req, res, next) {
    var db = mongoose.connection;
    restaurantModel.find({}, function(err, restaurants) {
        var restaurantsMap = {};

        restaurants.forEach(function(restaurant) {
            restaurantsMap[restaurant._id] = restaurant;
        });
		
        res.send(restaurantsMap);
    });
})

router.post('/review', function(req, res, next) {
    var db = mongoose.connection;
    var newReview = new reviewModel({
        client_id: req.body.client_id,
        td_account: req.body.td_account,
        stars: req.body.stars,
		comment: req.body.comment
    })
	console.log(req.body);
    restaurantModel.findOne({TD_account: req.body.td_account}, function (err, doc) {
        let total = 1;
        let rate = Number.parseFloat(req.body.stars);
        console.log(err);
        console.log(doc);
        console.log(doc.rate);
        if(doc.total !== 0){
            rate = (rate + (doc.total * doc.rate))/(total+doc.total);
            total = total+doc.total;
        }
        console.log(err);
        restaurantModel.updateOne(
            {TD_account: req.body.td_account},
            {rate: rate, total: total},
            function(err, document){
                console.log("error " + err);
                console.log("doc " + document.rate + " num " + document.total);
            });
    });

    reviewModel.updateOne({ client_id: req.body.client_id, td_account: req.body.td_account},
        {
            stars: req.body.stars,
			comment: req.body.comment
        }
        , function(err, result) {
        console.log(result)
        if (err) {
            //res.send({ status : "update failed"})
            console.error(err)
        }
        if(result.n == 0 && result.nModified == 0){
            newReview.save(function (err, fluffy) {
                if (err) {
                    res.send({ status : "save failed"})
                    return console.error(err)
                }
                res.send({status: "save succeeded"})
            });
        }else{
            res.send({status: "update succeeded"})
            return
        }
    });
    /*newReview.save(function (err, fluffy) {
        if (err) {
            res.send({ status : "save failed"})
            return console.error(err)
        }
        res.send({status: "succeeded"})
    });*/
})

router.get('/reviews/:id', function(req, res, next) {
    var id = req.params.id;
    var db = mongoose.connection;
    reviewModel.find({td_account: id}, function(err, reviews) {
        console.log(reviews)
        var reviewMap = {};

        reviews.forEach(function(review) {
            reviewMap[review._id] = review;
        });

        res.send(reviewMap);
    });
})
module.exports = router;
