require 'octokit'

module Slnky
  module Github
    class Client < Slnky::Client::Base
      def initialize
        Octokit.auto_paginate = true
        @token = config.github.token
        @org = config.github.org
        @hipchat_token = config.github.hipchat_token
        @hipchat_room = config.github.hipchat_room
        @filter = config.github.filter
        @github = Octokit::Client.new(access_token: @token)
      end

      def user
        @github.user
      end

      def org_repos
        @github.org_repos(@org)
      end

      def setup_hooks(repo)
        # don't do anything when not in production
        return unless config.production?
        # if filter is set and repo doesn't match, return
        return if @filter && repo !~ /^#{@filter}/
        # return if hipchat is already configured, this avoids overwriting config
        hooks = @github.hooks(repo)
        return if hooks.select {|h| h[:name] == 'hipchat'}.count > 0

        log.warn "repo '#{repo}' created, updating hooks"
        hipchat = Octokit.available_hooks.select{|h| h[:name] == 'hipchat'}.first
        config = {
            auth_token: @hipchat_token,
            room: @hipchat_room,
            # restrict_to_branch: "branch,names",
            # color: 'yellow',
            # server: "?",
            notify: true,
            # quiet_fork: true,
            quiet_watch: true,
            # quiet_comments: true,
            quiet_labels: true,
            quiet_assigning: true,
            # quiet_wiki: true,
        }
        options = {events: hipchat[:supported_events], active: true}
        @github.create_hook(repo, 'hipchat', config, options)
      end
    end
  end
end
