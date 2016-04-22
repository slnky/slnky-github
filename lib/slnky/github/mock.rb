module Slnky
  module Github
    class Mock < Slnky::Github::Client
      # unless there's something special you need to do in the initializer
      # use the one provided by the actual client object
      def initialize

      end

      # override methods of the client here to mock them for testing
      def user
        Slnky::Data.new({login: 'shawncatz'})
      end

      def org_repos
        repo = Slnky::Data.new({full_name: "shawncatz/test"})
        tmp = Slnky::Data.new(repos: [repo])
        tmp.repos
      end

      def setup_hooks(repo)
        "setup hooks: #{repo}"
      end
    end
  end
end
