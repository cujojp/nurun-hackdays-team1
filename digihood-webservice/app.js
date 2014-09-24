var port = process.env.PORT || 9000,
	auth = require('http-auth'),
	compression = require('compression'),
	basic = auth.basic({
    	realm: "Blu Homes Protected area",
    	file: __dirname + "/.htpasswd" 
	}),
	express = require('express'),
	app = express()
		.use(auth.connect(basic))
		.use(compression())
		.use(express.static('dist'))
		.listen(port);

console.log('Started express web server on port ' + port);
