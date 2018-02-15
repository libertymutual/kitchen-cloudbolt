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
      default_config :proto, 'https'
      default_config :port, 443
      default_config :wait, True
      default_config :group_id, nil
      default_config :owner_id, nil
      default_config :osbuild_id, nil
      default_config :app_ids, nil
      default_config :params, nil
      # Maybe we should required use of hostname templates
      default_config :hostname, nil
      default_config :preconfig, nil

      default_config :host do
        ENV['CLOUDBOLT_HOST']
      end

      default_config :user do
        ENV['CLOUDBOLT_USER']
      end

      default_config :pass do
        ENV['CLOUDBOLT_PASS']
      end

      required_config :host
      required_config :user
      required_config :pass
      required_config :group_id
      required_config :owner_id
      required_config :osbuild_id
      required_config :app_ids
      required_config :params
      required_config :hostname
      required_config :preconfig

      def create(state)
        # Assumes the output of cb_prov is the Server ID
        server = connection.cb_prov(
          config[:group_id],
          config[:env_id],
          config[:owner_id],
          config[:osbuild_id],
          config[:app_ids],
          config[:params],
          config[:hostname],
          config[:preconfigs],
          config[:wait])
        state[:group_id] = config[:group_id]
        state[:env_id] = config[:env_id]
        state[:hostname] = config[:hostname]
        state[:server_id] = server
        # Should lookup server metadata like IP, MAC, etc..
        # and store in state
      end

      def destroy(state)
        destroy.cb_decom(
          state[:group_id],
          state[:env_id],
          state[:server_id],
          config[:wait])
        state.delete(:server_id)
        state.delete(:hostname)
      end

      private

      def connection()
        return @connection unless @connection.nil?
        @connection = Cloudbolt.new(
          config[:proto],
          config[:host],
          config[:port],
          config[:user],
          config[:pass])
        @connection
      end

    end
  end
end

