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
      default_config :wait, false
      default_config :group_id, nil
      default_config :deploy_items, nil

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
      required_config :deploy_items

      def create(state)
        # Assumes the output of cb_order_blueprint is the Server ID
        # TODO Need to output server id and env id and store in state
        server = connection.cb_order_blueprint(
          config[:group_id],
          config[:deploy_items],
          config[:wait])
        server_id = server["_links"]["self"]["title"][/\d+/].to_i
        env_id = server["items"]["deploy_items"][0]["blueprint-items-arguments"]["build-item-Server"]["environment"]
        state[:group_id] = config[:group_id]
        state[:deploy_items] = config[:deploy_items]
        state[:server_id] = server_id
        state[:env_id] = env_id
        # Should lookup server metadata like IP, MAC, etc..
        # and store in state
      end

      def destroy(state)
        server_id = state['server_id']
        env_id = state['env_id']

        decom_item = Hash.new
        decom_item['environment'] = "/api/v2/environments/#{env_id}"
        decom_item['servers'] = ["/api/v2/servers/#{server_id}"]

        decom_items = Array.new
        decom_items << decom_item

        destroy.cb_decom_blueprint(
          state[:decom_items],
          config[:wait])
        state.delete(:server_id)
        state.delete(:env_id)
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

