# Generated on 2016-10-10 using generator-reveal 0.5.9
module.exports = (grunt) ->

    
    
    scripts_match = []
    clean =  (src,filepath) ->
        cleaned = src.replace(/(\r\n|\n|\r)/gm,"")
        matches = cleaned.match(/<script.*?>([\s\S]*?)<\/script>/gmi)
        if matches != null
            scripts_match.push elem2 for elem2 in matches
        cleaned_all = cleaned.replace(/<script.*?>([\s\S]*?)<\/script>/gmi, ' ')
        console.log(scripts_match)
        return cleaned_all

    #console.log(scripts.match(/<script.*?>([\s\S]*?)<\/script>/gmi))

    tst = grunt.file.readJSON 'slides/list.json'
    ind = tst.indexOf('index.md')
    tst.splice(ind,1)
    qsq = ('slides/'+ elem for elem in tst)
    #scripts_match = (elem.match(/<script.*?>([\s\S]*?)<\/script>/gmi) for elem in qsq)
    #console.log(qsq)
    #console.log(scripts_match)

    #console.log(scripts.replace(/<script.*?>([\s\S]*?)<\/script>/gmi, ' '))


    grunt.initConfig
        concat:
           
            options:
                separator: '","'
                banner: '["'
                footer: '"]'
                process: clean
    
            dist:
                src: qsq
                dest: 'slides/all.json'
    
  


        pkg: grunt.file.readJSON 'package.json'

        watch:

            rebuild:
                options:
                    livereload: true

                files:[
                    'slides/*.html'
                    'templates/*.*'
                    
                ]
                tasks: [
                    'built_json'
                    'buildIndex']

        

            index:
                files: [
                    'templates/_index.html'
                    'templates/_section.html'
                    'slides/list.json'
                ]
                tasks: [
                    'built_json'
                    'buildIndex']

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            jshint:
                files: ['js/*.js']
                tasks: ['jshint']
        
        connect:

            livereload:
                options:
                    port: 9000
                    # Change hostname to '0.0.0.0' to access
                    # the server from outside.
                    hostname: 'localhost'
                    base: '.'
                    open: true
                    livereload: true

        coffeelint:

            options:
                indentation:
                    value: 4
                max_line_length:
                    level: 'ignore'

            all: ['Gruntfile.coffee']

        jshint:

            options:
                jshintrc: '.jshintrc'

            all: ['js/*.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'slides/**'
                        'bower_components/**'
                        'js/**'
                        'resources/**'
                    ]
                    dest: 'dist/'
                },{
                    expand: true
                    src: ['index.html']
                    dest: 'dist/'
                    filter: 'isFile'
                }]

        


    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.registerTask 'test123',
        'assigns variales',
        ->
            console.log(grunt.option('sts'))


    grunt.registerTask 'built_json',
        'concats all json',
        ->
            slides_json = grunt.file.readJSON 'slides/list.json'
            index_index = slides_json.indexOf('index.md')
            slides_json.splice(index_index,1)
            real_array = ('slides/'+ elem for elem in slides_json)
            grunt.config.set('concat.dist.src', real_array)
            grunt.task.run('concat')
   


    grunt.registerTask 'buildIndex',
        'Build index.html from templates/_index.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_index.html'
            sectionTemplate = grunt.file.read 'templates/_section.html'
            slides = grunt.file.readJSON 'slides/all.json'
            scripts_all = scripts_match

            html = grunt.template.process indexTemplate, data:
                scripts:
                    scripts_all
                slides:
                    slides
                section: (slide) ->
                    grunt.template.process sectionTemplate, data:
                        slide:
                            slide
            grunt.file.write 'index.html', html

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'serve',
        'Run presentation locally and start watch process (living document).', [
            'built_json'
            'buildIndex'
            'connect:livereload'
            'watch'
        ]

    grunt.registerTask 'dist',
        'Save presentation files to *dist* directory.', [
            'test'
            'built_json'
            'buildIndex'
            'copy'
        ]

    

    # Define default task.
    grunt.registerTask 'default', [
        'test'
        'serve'
    ]
