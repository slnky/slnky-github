require 'slnky'
require 'octokit'

module Slnky
  module Service
    class Github < Base
      def initialize(url, options={})
        super(url, options)
        @token = config.github.token
        Octokit.auto_paginate = true
        @github = Octokit::Client.new(access_token: @token)
        @org = config.github.org
        @hipchat_token = config.github.hipchat_token
        @hipchat_room = config.github.hipchat_room
        @filter = config.github.filter
      end

      # when this message is sent, run the setup_hooks method
      # for all repos in the selected org
      subscribe 'slnky.github.hooks', :handle_hooks
      # when a new repo is created, setup hooks
      subscribe 'github.repo.create', :handle_repo

      def handler(name, data)
        name == 'slnky.service.test' &&
            data.hello == 'world!' &&
            @github.user.login == 'shawncatz'
      end

      def handle_hooks(name, data)
        repos =  @github.org_repos(@org)
        repos.each do |r|
          setup_hooks(r.full_name)
        end
        true
      end

      def handle_repo(name, data)
        repo = data.repository.full_name
        log :warn, "repo '#{repo}' created, updating hooks"
        setup_hooks(repo)
        true
      end

      protected

      def setup_hooks(repo)
        # if filter is set and repo doesn't match, return
        return if @filter && repo !~ /^#{@filter}/
        # return if hipchat is already configured, this avoids overwriting config
        return if hooks.select {|h| h[:name] == 'hipchat'}.count > 0
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
