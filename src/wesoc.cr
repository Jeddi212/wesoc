require "http/server"

messages = [] of String
SOCKET = [] of HTTP::WebSocket

ws_handler = HTTP::WebSocketHandler.new do |socket|
  puts "Socket opened"
  SOCKET << socket
  
  socket.on_message do |message|
    messages << message
    SOCKET.each_with_index { |socket, i|
      socket.send messages[i]
    }
  end
  
  socket.on_close do
    SOCKET.delete(socket)
    puts "Socket closed"
  end
end

server  = HTTP::Server.new([ws_handler])
address = server.bind_tcp "0.0.0.0", 3000
puts "Listening on ws://#{address}"
server.listen

