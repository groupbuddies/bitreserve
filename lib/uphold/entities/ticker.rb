# frozen_string_literal: true

module Uphold
  module Entities
    class Ticker < BaseEntity
      attribute :ask
      attribute :bid
      attribute :currency
      attribute :pair
    end
  end
end
