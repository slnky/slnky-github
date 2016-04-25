module Slnky
  module Github
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Github::Client.new
      end

      # # use docopt to define arguments and options
      # command :echo, 'respond with the given arguments', <<-USAGE.strip_heredoc
      #   Usage: echo [options] ARGS...
      #
      #   -h --help           print help.
      #   -x --times=TIMES    print x times [default: 1].
      # USAGE
      #
      # # handler methods receive request, response, and options objects
      # def handle_echo(request, response, opts)
      #   # parameters (non-option arguments) are available as accessors
      #   args = opts.args
      #   # as are the options themselves (by their 'long' name)
      #   1.upto(opts.times.to_i) do |i|
      #     # just use the log object to respond, it will automatically send it
      #     # to the correct channel.
      #     log.info args.join(" ")
      #   end
      # end

      command :setup_hooks, 'setup hooks for REPO', <<-USAGE.strip_heredoc
        Usage: setup_hooks [options] REPO

        the REPO must be full repo name (user/repo or org/repo)
        -h --help           print help.
        -f --force          overwrite hooks if they already exist
      USAGE
      def handle_setup_hooks(request, response, opts)
        repo = opts.repo
        log.warn "configuring hooks for repo '#{repo}'"
        client.setup_hooks(repo, force: opts.force)
      end

      # command :list_hooks, 'list hooks for all repos', <<-USAGE.strip_heredoc
      #   Usage: list_hooks [options] REPO
      #
      #   the REPO must be full repo name (user/repo or org/repo)
      #   -h --help           print help.
      # USAGE
      # def handle_list_hooks(request, response, opts)
      #   client.list_hooks(repo)
      # end
    end
  end
end
