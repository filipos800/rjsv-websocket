module RJSV
  module Plugins
    module Websocket

      require 'eventmachine'
      require 'em-websocket'

      require_relative './websocket/cli/arguments'
      require_relative './websocket/states'
      require_relative './websocket/server'

      class Init < RJSV::Plugin
        def initialize
          @arguments_cli = RJSV::Plugins::Websocket::CLI::Arguments
        end

        def description
          "Addition of websocket communication."
        end

        def arguments
          @arguments_cli.init(self)
        end

        def init()
          RJSV::Plugins::Websocket::States.main()
        end
      end

    end
  end
end
