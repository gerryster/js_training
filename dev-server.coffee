resolve = require('path').resolve
server = (connect = require 'connect')()

if process.argv.length < 3 then console.log "a directory is required"
else
  path = resolve process.argv[2]

  server.use use for use in [
    connect.favicon()
    connect.static path, maxAge: 1, hidden: true
  ]

  port = process.argv[3] or 3000
  server.listen port, ->
  	console.log "'serving #{path} on #{server.address().port}"