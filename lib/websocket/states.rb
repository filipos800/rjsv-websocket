module RJSV
  module Plugins
    module Websocket
      module States
        @server      = nil
        @is_activate = nil

        module_function

        def main()
          @is_activate = true
        end

        def create_server()
          return unless @is_activate

          @server = RJSV::Plugins::Websocket::Server.new
          @server.start()
        end#create_server

        def send_update_server()
          return unless @is_activate

          message = { type: 'update' }
          @server.send(message)
        end
      end
    end
  end

  module CLI
    module States
      module_function

      def watch_state(options_cli)
        if options_cli[:watch]
          Core::Event.print('message', 'There is now a watch for edited files.')
          RJSV::Plugins::Websocket::States.create_server()

          paths = options_cli[:source].split(RJSV::Constants::PATH_SPLIT)
          RJSV::Watch.modified_files(*paths) do |modified, added, removed|
            unless added.empty?
              added.each do |path|
                translate_state(path, options_cli)
              end
            end
        
            unless modified.empty?
              modified.each do |path|
                translate_state(path, options_cli)
              end
            end
        
            unless removed.empty?
              removed.each do |path|
                path_output = Core::Files.change_path_to_output(path, options_cli)
                Core::Files.remove(path_output)
                Core::Event.print('deleted', path_output)
              end
            end

            RJSV::Plugins::Websocket::States.send_update_server()
          end
        end
      end#watch_state
    end
  end
end
