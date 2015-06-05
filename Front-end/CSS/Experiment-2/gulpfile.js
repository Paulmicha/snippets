
/**
 *  Gulp CSS compilation
 *  
 *  Installation :
 *  $ npm install
 *  
 *  Usage :
 *  gulp [watch]
 *  
 *  @see https://www.npmjs.com/package/gulp-cssnext
 *  @see https://www.npmjs.com/package/gulp-pixrem
 */

var gulp = require('gulp'),
    concat = require('gulp-cssnext'),
    uglify = require('gulp-pixrem');

gulp.task("stylesheets", function()
{
    gulp.src("index.css")
        .pipe(pixrem())
        .pipe(cssnext({
            compress: true
        }))
        .pipe(gulp.dest("main.css"));
});


//  The default task (called when you run `gulp` from cli)
//gulp.task('default', ['stylesheets']);

