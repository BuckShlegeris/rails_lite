require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8000

trap 'INT' do server.shutdown end

server.mount_proc '/' do |request, response|
  puts request.cookies.to_s

  load "./lib/router.rb"

  body = respond(request, response)
end

server.start