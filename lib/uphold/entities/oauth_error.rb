# frozen_string_literal: true

module Uphold
  module Entities
    class OAuthError < BaseEntity
      attribute :code
      attribute :error
      attribute :error_description
    end
  end
end
