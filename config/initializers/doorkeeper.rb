# frozen_string_literal: true

# Doorkeeper https://github.com/doorkeeper-gem/doorkeeper is the OAuth engine that secures /api.
# To test: go to /oauth_test and follow the instructions.

# do not auto initialize all the models
# will make `rails runner 1` fail because the models were preloaded
module Doorkeeper
  autoload :AccessGrant, 'doorkeeper/orm/active_record/access_grant'
  autoload :AccessToken, 'doorkeeper/orm/active_record/access_token'
  autoload :Application, 'doorkeeper/orm/active_record/application'
  autoload :BaseRecord, 'doorkeeper/orm/active_record/base_record'
  module Orm
    module ActiveRecord
      class << self
        undef initialize_models!
        def initialize_models!
        end
      end
    end
  end
end

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    request.env['warden'].user
  end

  default_scopes :default
  base_controller 'DoorkeeperBaseController'
  force_ssl_in_redirect_uri !%w[development test].include?(Rails.env)
end
