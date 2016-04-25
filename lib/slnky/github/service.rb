module Slnky
  module Github
    class Service < Slnky::Service::Base
      attr_writer :client
      def client
        @client ||= Slnky::Github::Client.new
      end

      subscribe 'slnky.service.test', :handle_test
      # you can also subscribe to heirarchies, this gets
      # all events under something.happened
      # subscribe 'something.happened.*', :other_handler

      # when this message is sent, run the setup_hooks method
      # for all repos in the selected org
      subscribe 'slnky.github.hooks', :handle_hooks
      # when a new repo is created, setup hooks
      subscribe 'github.repo.create', :handle_repo

      def handle_test(name, data)
        name == 'slnky.service.test' &&
            data.hello == 'world!' &&
            client.user.login == 'shawncatz'
      end

      def handle_hooks(name, data)
        # don't do anything when not in production
        # return true if @environment != 'production'
        repos = client.org_repos
        repos.each do |r|
          client.setup_hooks(r.full_name)
        end
      end

      def handle_repo(name, data)
        repo = data.repository.full_name
        log.warn "repo '#{repo}' created, updating hooks"
        client.setup_hooks(repo)
      end
    end
  end
end
