'use strict'
module.exports = (grunt) ->

  grunt.initConfig
    nodeunit:
      tests: ['test/*_test.js']

    coffee:
      src:
        expand: yes
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'src'
        ext: '.js'

      tests:
        expand: yes
        cwd: 'test'
        src: ['**/*.coffee']
        dest: 'test'
        ext: '.js'

    watch:
      src:
        files: ['**/*.coffee']
        tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'test', ['coffee', 'nodeunit']

  grunt.registerTask 'default', ['test']
