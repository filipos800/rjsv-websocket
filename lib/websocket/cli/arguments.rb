module RJSV
  module Plugins
    module Websocket
      module CLI

        module Arguments
          @options = {
          }

          module_function

          def options
            @options
          end

          def init(parent)
            OptionParser.parse do |parser|
              parser.banner(
                "#{parent.description()}\n\n" +
                "Usage: #{APP_NAME} #{parent.name()} [options]\n" +
                "\nOptions:"
              )

              parser.on( "-h", "--help", "Show help" ) do
                puts parser
                exit
              end
            end
          end
        end

      end
    end
  end
end