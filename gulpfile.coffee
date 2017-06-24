# npm i gulp coffee-script gulp-connect gulp-clean gulp-coffee gulp-sass gulp-autoprefixer gulp-sourcemaps gulp-concat  gulp-uglify gulp-requirejs --save-dev

gulp = require 'gulp'
connect = require 'gulp-connect'

sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
clean = require 'gulp-clean'     # delete file


gulp.task 'connect', ->
  connect.server
    port: 4444
    livereload: on
    root: '.'

gulp.task 'sass', ->
  gulp.src 'css/sass/main.sass'
    .pipe sourcemaps.init()
    .pipe sass(outputStyle: 'compressed')
#     .pipe sourcemaps.write '../public/css/map'
    .pipe prefix('last 3 version')   # 'last 15 version'
    .pipe concat 'main.css'
    .pipe gulp.dest 'css'
    .pipe do connect.reload


gulp.task 'coffee', ->
  gulp.src 'js/coffee/**/*.coffee'
    .pipe do coffee
    .pipe concat 'main.js'
    .pipe gulp.dest 'js'
    .pipe do connect.reload

gulp.task 'update', ->
  gulp.src '.'
    .pipe do connect.reload

gulp.task 'watch', ->
  gulp.watch 'css/sass/**/*.sass', ['sass']
  gulp.watch 'js/coffee/**/*.coffee', ['coffee']
  gulp.watch '*', ['update']


gulp.task 'default', ['sass', 'coffee', 'watch', 'connect']