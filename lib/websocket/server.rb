module RJSV
  module Plugins
    module Websocket

      class Server
        def initialize(port = 7071)
          @port = port
          @clients = []
        end

        def start
          Thread.new do
            EM.run do
              Core::Event.print('websocket', "ws://localhost:#{@port}")

              EM::WebSocket.run(host: "0.0.0.0", port: @port) do |ws|
                ws.onopen do
                  @clients << ws
                end

                ws.onmessage do |msg|
                  @clients.each { |c| c.send(msg) }
                end

                ws.onclose do
                  @clients.delete(ws)
                end
              end
            end
          end
        end

        def send(message)
          @clients.each do |c|
            data = JSON.generate(message)
            c.send(data)
          end
        end
      end

    end
  end
end