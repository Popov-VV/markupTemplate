gulp = require 'gulp'
connect = require 'gulp-connect'
argv = require('yargs').argv
clean = require 'gulp-clean'
rename = require "gulp-rename"

colors = require 'colors/safe'
sass = require 'gulp-sass'
inlineCss = require 'gulp-inline-css'
prefix = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'

coffee = require 'gulp-coffee'
minify = require 'gulp-minify'

pug = require 'gulp-pug'
imagemin = require 'gulp-imagemin'

nameEmailTemplate = 'bookingEmail'

# получение названия шаблона email
if argv.name and argv.name isnt true then nameEmailTemplate = argv.name else nameEmailTemplate = 'example'

# ======= main tasks =======

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
    .pipe sass(
      outputStyle: 'compressed'
    )
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
    .pipe minify()
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



# ======= email tasks =======

gulp.task 'connectEmail', ->
  connect.server
    port: 4444
    livereload: on
    root: './email/' + nameEmailTemplate + '/resultEmail'
    fallback: './email/' + nameEmailTemplate + '/resultEmail/' + nameEmailTemplate + '.html'


gulp.task 'emailTemplatePug', ->
  gulp.src('email/' + nameEmailTemplate + '/template.pug')
    .pipe pug
      pretty: true
    .pipe rename nameEmailTemplate + '.html'
    .pipe gulp.dest './email/' + nameEmailTemplate + '/resultEmail/'
    .pipe do connect.reload


gulp.task 'sassEmailTemplate', ->
  gulp.src './email/' + nameEmailTemplate + '/style.sass'
    .pipe sass()
    .pipe prefix('last 15 version')
    .pipe concat 'style.css'
    .pipe gulp.dest './email/' + nameEmailTemplate + '/resultEmail/'
    .pipe do connect.reload


gulp.task 'buildMail', ['emailTemplatePug', 'sassEmailTemplate'], ->
  gulp.src('./email/' + nameEmailTemplate + '/resultEmail/' + nameEmailTemplate + '.html')
    .pipe inlineCss()
#    .pipe rename nameEmailTemplate + '-build.html'
    .pipe gulp.dest('./email/' + nameEmailTemplate + '/resultEmail/')
    .pipe do connect.reload

  gulp.src('./email/' + nameEmailTemplate + '/resultEmail/style.css')
    .pipe clean ''


gulp.task 'watchEmail', ->
  gulp.watch 'email/' + nameEmailTemplate + '/template.pug', ['buildMail']
  gulp.watch 'email/' + nameEmailTemplate + '/**/*.sass', ['buildMail']



gulp.task 'default', ['template', 'sass', 'coffee', 'watch', 'connect']

gulp.task 'email', [
                    'sassEmailTemplate',
                    'emailTemplatePug',
                    'connectEmail',
                    'buildMail',
                    'watchEmail'
                    ]
