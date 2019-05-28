# frozen_string_literal: true

module Uphold
  module Entities
    class Card < BaseEntity
      attribute :id
      attribute :address
      attribute :label
      attribute :currency
      attribute :balance
      attribute :available
      attribute :lastTransactionAt, DateTime
      attribute :settings
    end
  end
end
