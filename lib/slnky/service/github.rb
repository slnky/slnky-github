require 'slnky'

module Slnky
  module Service
    class Github < Base
      subscribe 'slnky.service.test', :handler
      # you can also subscribe to heirarchies, this gets
      # all events under something.happened
      # subscribe 'something.happened.*', :other_handler

      def handler(name, data)
        name == 'slnky.service.test' && data.hello == 'world!'
      end
    end
  end
end
