var express = require('express');
var router = express.Router();

/* GET Home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});


/**
 * Will run from a form submision and submit new data.
 */
router.post('/api/add-beacon/', function(req, res) {
  // Set our internal DB variable
});


/**
 * Will remove a location from the database
 */
router.delete('/api/remove-beacon/:id', function(req, res) {
});



/**
 * Landing page for locations. Will load all locations in the database.
 */
router.get('/api/get-beacon/data.json', function(req, res) {
});


/**
 * Returns an json array of information based on the beacon.
 */
router.get('/api/get-beacon/:id/data.json', function(req, res) {
  //var db = req.db;
  //var collection = db.collection('locationscollection');
  //var locationId = req.params.id;

  //console.log(locationId);
  //collection.findOne({'_id': ObjectID(locationId)},{},function(err, results){
    //console.log(results);
    //if (err) {
      //return res.json({ "error" : err });
    //} else {
      //return res.json({ "location" : results });
    //}
  //});  
});

module.exports = router;
