var gulp = require('gulp');
var gutil = require('gulp-util');
var Q = require('q');
var exec = require('child_process').exec;
var print = require('./helpers/print');

function shell(command) {
    var deferred = Q.defer();
    var proc = exec(command, {
        maxBuffer: 1024 * 1024
    }, function(error, stdout, stderr) {
        if (error !== null) {
            print.stderr('exec error: ' + error);
            deferred.reject();
        } else {
            deferred.resolve();
        }
    });
    proc.stdout.on('data', print.stdout);
    proc.stderr.on('data', print.stderr);
    return deferred.promise;
}

/**
 * Simulation task
 */
gulp.task('simulate', function() {
    // Build Java command
    var classpath = [];
    classpath.push('../peersim-1.0.5/peersim-1.0.5.jar');
    classpath.push('../peersim-1.0.5/djep-1.0.0.jar');
    classpath.push('../peersim-1.0.5/jep-2.3.0.jar');
    classpath.push('../peersim-cyclon/bin');
    classpath.push('../peersim-vivaldi/bin');
    classpath.push('../peersim-closepeer/bin');
    classpath.push('../peersim-respcoord/bin');
    classpath.push('bin');

    var cp_arg = ' -cp ' + classpath.join(':');
    var class_arg = 'peersim.Simulator';

    // Execute Java command
    shell('java' + [cp_arg, class_arg, sim_id + '.conf'].join(' '));
});

/**
 * Plot task
 */
gulp.task('plot', function() {
    print.stdout("Plotting graph\n");
    shell('R CMD BATCH plot-' + sim_id + '.R');
});

/**
 * Vivaldi Convergence
 */
gulp.task('viv-conv-conf', function() {
    sim_id = 'viv-conv';
});

gulp.task('viv-conv-prep', function() {
    return shell('rm -rf vivaldi-tmp && mkdir vivaldi-tmp');
});

gulp.task('viv-conv', ['viv-conv-conf', 'viv-conv-prep', 'simulate']);

gulp.task('plot-viv-conv', ['viv-conv-conf', 'plot']);

/**
 * Default task
 */
gulp.task('default', ['viv-conv']);
