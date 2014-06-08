# -*- mode: ruby; coding: utf-8 -*-

module JsonCli
  module Command
    # Base command class
    class Base
      def initialize(options)
        @output = options[:out]
      end
    end
  end
end
