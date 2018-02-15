# -*- encoding: utf-8 -*-
#
# Author:: Colin Thorp (<colin@cloudbolt.io>)
#
require 'cloudbolt'
require 'kitchen'

module Kitchen

  module Driver

    # CloudBolt API driver for Test Kitchen.
    #
    # @author Colin Thorp <colin@cloudbolt.io>
    class Cloudbolt < Kitchen::Driver::Base
      def create(state)
        # Need to validate if sate is defined and passed from test kitchen config
        @state = state
        connection.cb_prov(state[:group_id], state[:env_id], state[:owner_id], state[:osbuild_id], state[:app_ids],
                state[:params], state[:hostname], state[:preconfigs], state[:wait])
        # Rescue / Recover from errors
      rescue Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      def destroy(state)
        # Need to validate if sate is defined and passed from test kitchen config
        @state = state
        destroy.cb_decom(state[:group_id], state[:env_id], state[:server_ids], state[:wait])
        # Rescue / Recover from errors
      rescue  Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      private

      def connection(state)
        # connect with cloudbolt-gem
        return @connection unless @connection.nil?
        # Need to figure out how to get connection details
        # Maybe pull opts from state, added the arg to the def
        opts = {
          proto: 'https',
          host: 'cloudbolt.example.com',
          port: 443,
          user: 'cb_user',
          pass: 'password',
        }
        @connection = Cloudbolt.new(opts[:proto], opts[:host], opts[:port], opts[:user], opts[:pass])
        @connection
      end

    end
  end
end

