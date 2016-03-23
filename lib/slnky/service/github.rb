require 'slnky'
require 'octokit'

module Slnky
  module Service
    class Github < Base
      def initialize(url, options={})
        super(url, options)
        @token = config.github.token
        @github = Octokit::Client.new(access_token: @token)
      end

      def handler(name, data)
        name == 'slnky.service.test' &&
            data.hello == 'world!' &&
            @github.user.login == 'shawncatz'
      end
    end
  end
end
