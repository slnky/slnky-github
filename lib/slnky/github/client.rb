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

      def setup_hooks(repo, options={})
        options = {force: false}.merge(options)
        # don't do anything when not in production
        return unless config.production?
        # if filter is set and repo doesn't match, return
        return if @filter && repo !~ /^#{@filter}/

        setup_hipchat_hooks(repo, options)
      end

      def list_hooks
        org_repos.each do |repo|
          hooks = @github.hooks(repo.full_name)
          hipchat = hooks.select {|h| h[:name] == 'hipchat'}.first
          if hipchat
            log.info "repo: #{repo.full_name} => #{hipchat[:config][:room]}"
            log.info "      last: #{hipchat[:last_response][:code]} #{hipchat[:last_response][:status]}"
          end
        end
      end

      def setup_hipchat_hooks(repo, options={})
        hooks = @github.hooks(repo)
        if hooks.select {|h| h[:name] == 'hipchat'}.count > 0 && !options[:force]
          # return if hipchat is already configured, this avoids overwriting config
          log.info "hipchat hook already configured, not forcing"
          return
        end

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
