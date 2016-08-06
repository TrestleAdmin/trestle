module.exports = function(grunt) {
  require('jit-grunt')(grunt);

  grunt.initConfig({
      pkg: grunt.file.readJSON('package.json'),

      banner: '/*!\n' +
      ' * Bootstrap Confirmation <%= pkg.version %>\n' +
      ' * Copyright 2013 Nimit Suwannagate <ethaizone@hotmail.com>\n' +
      ' * Copyright 2014-<%= grunt.template.today("yyyy") %> Damien "Mistic" Sorel <contact@git.strangeplanet.fr>\n' +
      ' * Licensed under the Apache License, Version 2.0\n' +
      ' */',

      // serve folder content
      connect: {
        dev: {
          options: {
            port: 9000,
            livereload: true
          }
        }
      },

      // watchers
      watch: {
        options: {
          livereload: true
        },
        dev: {
          files: ['bootstrap-confirmation.js', 'example/**'],
          tasks: []
        }
      },

      // open example
      open: {
        dev: {
          path: 'http://localhost:<%= connect.dev.options.port%>/example/index.html'
        }
      },

      // replace version number
      replace: {
        dist: {
          options: {
            patterns: [
              {
                match: /(Confirmation\.VERSION = ').*(';)/,
                replacement: '$1<%= pkg.version %>$2'
              }
            ]
          },
          files: {
            'bootstrap-confirmation.js': [
              'bootstrap-confirmation.js'
            ]
          }
        }
      },

      // compress js
      uglify: {
        options: {
          banner: '<%= banner %>\n',
          mangle: {
            except: ['$']
          }
        },
        dist: {
          files: {
            'bootstrap-confirmation.min.js': [
              'bootstrap-confirmation.js'
            ]
          }
        }
      },

      // jshint tests
      jshint: {
        lib: {
          files: {
            src: [
              'bootstrap-confirmation.js'
            ]
          }
        }
      }
    }
  );

  grunt.registerTask('default', [
    'replace',
    'uglify'
  ]);

  grunt.registerTask('test', [
    'jshint'
  ]);

  grunt.registerTask('serve', [
    'connect',
    'open',
    'watch'
  ]);

};
