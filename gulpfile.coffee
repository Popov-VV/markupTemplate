gulp = require 'gulp'
connect = require 'gulp-connect'

colors = require 'colors/safe'
sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
pug = require 'gulp-pug'
uglify = require 'gulp-uglify'
clean = require 'gulp-clean'

imagemin = require 'gulp-imagemin'


gulp.task 'connect', ->
  connect.server
    port: 4444
    livereload: on
    root: 'app'


gulp.task 'template', ->
  gulp.src('assets/template/*.pug')
    .pipe pug({
      pretty: true
    })
    .on 'error', (err) ->
      console.log colors.red  err.toString()
      this.emit 'end'
    .pipe gulp.dest './app'
    .pipe do connect.reload

gulp.task 'sass', ->
  gulp.src 'assets/sass/main.sass'
    .pipe sourcemaps.init()
    .pipe sass(outputStyle: 'compressed')
    .on 'error', (err) ->
      console.log colors.red err.toString()
      this.emit 'end'
    # .pipe sourcemaps.write '../public/css/map'
    .pipe prefix('last 3 version')   # 'last 15 version'
    .pipe concat 'main.css'
    .pipe gulp.dest './app/css'
    .pipe do connect.reload


gulp.task 'coffee', ->
  gulp.src 'assets/coffee/**/*.coffee'
    .pipe do coffee
    .on 'error', (err) ->
      console.log colors.red err.toString()
      this.emit 'end'
    .pipe concat 'main.js'
    .pipe gulp.dest './app/js'
    .pipe do connect.reload

gulp.task 'update', ->
  gulp.src '.'
    .pipe do connect.reload

gulp.task 'images', ->
gulp.src('resources/assets/images/**/*')
  .pipe(imagemin())
  .pipe gulp.dest('public/images/')


gulp.task 'watch', ->
  gulp.watch 'assets/template/**/*.pug', ['template']
  gulp.watch 'assets/sass/**/*.sass', ['sass']
  gulp.watch 'assets/coffee/**/*.coffee', ['coffee']
  # gulp.watch 'js/*', ['update']


gulp.task 'default', ['template', 'sass', 'coffee', 'watch', 'connect']
