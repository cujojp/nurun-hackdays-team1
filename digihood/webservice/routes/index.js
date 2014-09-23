var express = require('express');
var router = express.Router();

/* GET Home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});


/**
 * Will run from a form submision and submit new data.
 */
router.post('/api/add-location/', function(req, res) {
  // Set our internal DB variable
});


/**
 * Will remove a location from the database
 */
router.delete('/api/remove-location/:id', function(req, res) {
});


/**
 * Will let users edit a location from the database.
 */
router.post('/api/edit-location/:id', function(req, res) {
});



/**
 * Landing page for locations. Will load all locations in the database.
 */
router.get('/api/get-locations/data.json', function(req, res) {
});


/**
 * Landing page for locations. Will load all locations in the database.
 */
router.get('/api/get-location/:id/data.json', function(req, res) {
});

module.exports = router;
