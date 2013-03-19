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

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'

  grunt.registerTask 'test', ['coffee', 'nodeunit']

  grunt.registerTask 'default', ['test']
