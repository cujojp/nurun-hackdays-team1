var gulp = require('gulp');
var include = require('gulp-include');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var sass = require('gulp-sass');
var notify = require('gulp-notify');
var config = require('./_config');
var embedlr = require('gulp-embedlr');
var refresh = require('gulp-livereload');
var lrserver = require('tiny-lr')();
var livereload = require('connect-livereload');
var livereloadport = 35729;
var serverport = 5000;

gulp.task('watch', function() {
  gulp.watch('js/*.js', ['scripts']);
});

// Starts the express server.
// Taken from app.js, so this could probably be a lot
// cleaner.
gulp.task('startexpress', function() {
  var express = require('express');
  var path = require('path');
  var favicon = require('static-favicon');
  var logger = require('morgan');
  var cookieParser = require('cookie-parser');
  var bodyParser = require('body-parser');

  var routes = require('./routes/index');

  var app = express();

  // view engine setup
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');
  app.set('port', (process.env.PORT || 5000))

  app.use(favicon());
  app.use(logger('dev'));
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded());
  app.use(cookieParser());
  app.use(livereload({
    port: livereloadport
  }));

  // Make our db accessible to our router
  app.use(function(req,res,next){
    next();
  });


  app.use(express.static(path.join(__dirname, 'public')));

  // define our routes and methods to call.
  app.use('/', routes);
  app.use('/location', routes);

  /// catch 404 and forwarding to error handler
  app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
  });

  /// error handlers
  // development error handler
  // will print stacktrace
  if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
      res.status(err.status || 500);
      res.render('error', {
        message: err.message,
        error: err
      });
    });
  }

  // production error handler
  // no stacktraces leaked to user
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: {}
    });
  });


  app.use(express.static(__dirname));
  app.listen(app.get('port'), function() {
    console.log("Node app is running at localhost:" + app.get('port'));
  });  

  //Set up your livereload server
  lrserver.listen(livereloadport);

  module.exports = app;
});

// Compiles scss files.
gulp.task('sass', function () {
  gulp.src('public/sass/**/*.scss')
      .pipe(sass({
        errLogToConsole: true
      }))
      .pipe(gulp.dest('./public/stylesheets'))
      .pipe(refresh(lrserver));
});

// Concatenate & Minify JS
gulp.task('scripts', function() {
  return gulp.src('public/javascripts/base/global.js')
      .pipe(include())
      .pipe(concat('all.js'))
      .pipe(gulp.dest('./public/javascripts'))
      .pipe(include())
      .pipe(concat('all.min.js'))
      .pipe(uglify())
      .pipe(gulp.dest('./public/javascripts'))
      .pipe(refresh(lrserver))
      .pipe(notify({ message: 'Script Includes Complete' }));

});

// Watch Our Files
gulp.task('watch', function() {
  gulp.watch([
    'public/javascripts/**/*.js', 
    'public/sass/**/*.scss'], ['sass' ,'scripts']);
});

gulp.task('default', ['sass', 'startexpress', 'scripts', 'watch']);
