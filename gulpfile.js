var argv, clean, coffee, colors, concat, connect, gulp, imagemin, inlineCss, minify, nameEmailTemplate, prefix, pug, rename, sass, sourcemaps;

gulp = require('gulp');
connect = require('gulp-connect');
argv = require('yargs').argv;
clean = require('gulp-clean');
rename = require("gulp-rename");
colors = require('colors/safe');
sass = require('gulp-sass');
inlineCss = require('gulp-inline-css');
prefix = require('gulp-autoprefixer');
sourcemaps = require('gulp-sourcemaps');
concat = require('gulp-concat');
coffee = require('gulp-coffee');
minify = require('gulp-minify');
pug = require('gulp-pug');
imagemin = require('gulp-imagemin');
nameEmailTemplate = 'example';

if (argv.name && argv.name !== true) {
  nameEmailTemplate = argv.name;
} else {
  nameEmailTemplate = 'example';
}


gulp.task('connect', function() {
  connect.server({
    port: 4444,
    livereload: true,
    root: 'app'
  });
});

gulp.task('template', function() {
  return gulp.src('assets/template/*.pug').pipe(pug({
    pretty: true
  })).on('error', function(err) {
    console.log(colors.red(err.toString()));
    return this.emit('end');
  }).pipe(gulp.dest('./app')).pipe(connect.reload());
});

gulp.task('sass', function() {
  return gulp.src('assets/sass/main.sass').pipe(sourcemaps.init()).pipe(sass({
    outputStyle: 'compressed'
  })).on('error', function(err) {
    console.log(colors.red(err.toString()));
    return this.emit('end');
  }).pipe(prefix('last 3 version')).pipe(concat('main.css')).pipe(gulp.dest('./app/css')).pipe(connect.reload());
});

gulp.task('coffee', function() {
  return gulp.src('assets/coffee/**/*.coffee')
    .pipe(coffee())
    .on('error', function(err) {
      console.log(colors.red(err.toString()));
      return this.emit('end');
    })
    .pipe(concat('main.js'))
    .pipe(minify())
    .pipe(gulp.dest('./app/js'))
    .pipe(connect.reload());
});

gulp.task('update', function() {
  return gulp.src('.')
    .pipe(connect.reload());
});

gulp.task('images', function() {
  return gulp.src('resources/assets/images/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest('public/images/'));
});

gulp.task('watch', function(done) {
  gulp.watch('assets/template/**/*.pug', gulp.series('template'));
  gulp.watch('assets/sass/**/*.sass', gulp.series('sass'));
  gulp.watch('assets/coffee/**/*.coffee', gulp.series('coffee'));
  done();
});

gulp.task('connectEmail', function() {
  return connect.server({
    port: 4444,
    livereload: true,
    root: './email/' + nameEmailTemplate + '/resultEmail',
    fallback: './email/' + nameEmailTemplate + '/resultEmail/' + nameEmailTemplate + '.html'
  });
});

gulp.task('emailTemplatePug', function() {
  return gulp.src('email/' + nameEmailTemplate + '/template.pug')
    .pipe(pug({
      pretty: true
    }))
    .pipe(rename(nameEmailTemplate + '.html'))
    .pipe(gulp.dest('./email/' + nameEmailTemplate + '/resultEmail/'))
    .pipe(connect.reload());
});

gulp.task('sassEmailTemplate', function() {
  return gulp.src('./email/' + nameEmailTemplate + '/style.sass')
    .pipe(sass())
    .pipe(prefix('last 15 version'))
    .pipe(concat('style.css'))
    .pipe(gulp.dest('./email/' + nameEmailTemplate + '/resultEmail/'))
    .pipe(connect.reload());
});

gulp.task('buildMail', gulp.series('emailTemplatePug', 'sassEmailTemplate', function(done) {
    gulp.src('./email/' + nameEmailTemplate + '/resultEmail/' + nameEmailTemplate + '.html')
      .pipe(inlineCss())
      .pipe(gulp.dest('./email/' + nameEmailTemplate + '/resultEmail/'))
      .pipe(connect.reload());

    gulp.src('./email/' + nameEmailTemplate + '/resultEmail/style.css')
      .pipe(clean(''));

    console.log('Email rebuild! Done!')

    done();
  }));

gulp.task('watchEmail', function(done) {
  gulp.watch('email/' + nameEmailTemplate + '/template.pug', gulp.series('buildMail'));
  gulp.watch('email/' + nameEmailTemplate + '/**/*.sass', gulp.series('buildMail'));
  done();
});

gulp.task('default', gulp.series('template', 'sass', 'coffee', 'watch', 'connect'));

gulp.task('email', gulp.series('buildMail', 'watchEmail', 'connectEmail'));

