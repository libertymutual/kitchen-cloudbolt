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
      default_config :wait_time, 5
      default_config :domain, nil
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
      required_config :domain

      def create(state)
        response = connection.order_blueprint(
          config[:group_id],
          config[:deploy_items],
          config[:wait],
          config[:wait_time])
        order_id = response["_links"]["self"]["title"][/\d+/].to_i
        state[:order_id] = order_id
        server = connection.get_server_from_order(order_id)
        hostname = server[:hostname]
        if not hostname.include? config[:domain]
          state[:hostname] = hostname + "." + config[:domain]
        else
          state[:hostname] = hostname
        end
        state[:server_id] = server[:id]
        state[:group_id] = config[:group_id]
        state[:deploy_items] = config[:deploy_items]
      end

      def destroy(state)
        return unless state[:server_id]
        
        server_id = state[:server_id]
        server = connection.get_server(server_id)
        environment = server["_links"]["environment"]["href"]

        decom_item = Hash.new
        decom_item[:environment] = environment
        decom_item[:servers] = ["/api/v2/servers/#{server_id}"]

        decom_items = Array.new
        decom_items << decom_item

        connection.decom_blueprint(
          config[:group_id],
          decom_items,
          config[:wait],
          config[:wait_time])
        state.delete(:server_id)
      end

      private

      def connection()
        return @connection unless @connection.nil?
        @connection = CloudboltAPI::Cloudbolt.new(
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
