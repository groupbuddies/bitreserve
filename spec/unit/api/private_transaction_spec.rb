# frozen_string_literal: true

require 'spec_helper'

describe Uphold::API::PrivateTransaction do
  let(:client) { Uphold::Client.new }

  context '#create_transaction' do
    it 'creates a transaction for a specific card' do
      card_id = '1234'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::CARD_PRIVATE_TRANSACTIONS, ':card' => card_id),
        Uphold::Entities::Transaction,
        client.authorization_header,
        card_id: card_id, denomination: { currency: 'USD', amount: 10 }, destination: 'foo@bar.com'
      )
      allow(Uphold::Request).to receive(:perform_with_object)

      client.create_transaction(card_id: card_id, currency: 'USD', amount: 10, destination: 'foo@bar.com')

      expect(Uphold::Request).to have_received(:perform_with_object).
        with(:post, request_data)
    end
  end

  context '#commit_transaction' do
    it 'commits a transaction for a specific card' do
      card_id = '1234'
      transaction_id = '4567'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::COMMIT_TRANSACTION, ':card' => card_id, ':id' => transaction_id),
        Uphold::Entities::Transaction,
        client.authorization_header
      )
      allow(Uphold::Request).to receive(:perform_with_object)

      client.commit_transaction(card_id: card_id, transaction_id: transaction_id)

      expect(Uphold::Request).to have_received(:perform_with_object).
        with(:post, request_data)
    end
  end

  context '#create_and_commit_transaction' do
    it 'creates a transaction for a specific card' do
      card_id = '1234'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::CREATE_AND_COMMIT_TRANSACTION, ':card' => card_id),
        Uphold::Entities::Transaction,
        client.authorization_header,
        card_id: card_id, denomination: { currency: 'USD', amount: 10 }, destination: 'foo@bar.com'
      )
      allow(Uphold::Request).to receive(:perform_with_object)

      client.create_and_commit_transaction(card_id: card_id, currency: 'USD', amount: 10, destination: 'foo@bar.com')

      expect(Uphold::Request).to have_received(:perform_with_object).
        with(:post, request_data)
    end
  end

  context '#cancel_transaction' do
    it 'cancels a transaction for a specific card' do
      card_id = '1234'
      transaction_id = '4567'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::CANCEL_TRANSACTION, ':card' => card_id, ':id' => transaction_id),
        Uphold::Entities::Transaction,
        client.authorization_header
      )
      allow(Uphold::Request).to receive(:perform_with_object)

      client.cancel_transaction(card_id: card_id, transaction_id: transaction_id)

      expect(Uphold::Request).to have_received(:perform_with_object).
        with(:post, request_data)
    end
  end

  context '#resend_transaction' do
    it 'resends a transaction for a specific card' do
      card_id = '1234'
      transaction_id = '4567'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::RESEND_TRANSACTION, ':card' => card_id, ':id' => transaction_id),
        Uphold::Entities::Transaction,
        client.authorization_header
      )
      allow(Uphold::Request).to receive(:perform_with_object)

      client.resend_transaction(card_id: card_id, transaction_id: transaction_id)

      expect(Uphold::Request).to have_received(:perform_with_object).
        with(:post, request_data)
    end
  end

  context '#all_user_transactions' do
    it 'lists all the transactions associated with the current user' do
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints::USER_PRIVATE_TRANSACTIONS,
        Uphold::Entities::Transaction,
        client.authorization_header.merge(client.pagination_header_for_range(0..4))
      )
      allow(Uphold::Request).to receive(:perform_with_objects)

      client.all_user_transactions

      expect(Uphold::Request).to have_received(:perform_with_objects).
        with(:get, request_data)
    end
  end

  context '#all_card_transactions' do
    it 'lists all the transactions associated with a specific card' do
      card_id = '1234'
      request_data = Uphold::RequestData.new(
        Uphold::Endpoints.with_placeholders(Uphold::Endpoints::CARD_PRIVATE_TRANSACTIONS, ':card' => card_id),
        Uphold::Entities::Transaction,
        client.authorization_header.merge(client.pagination_header_for_range(0..4))
      )
      allow(Uphold::Request).to receive(:perform_with_objects)

      client.all_card_transactions(card_id: card_id)

      expect(Uphold::Request).to have_received(:perform_with_objects).
        with(:get, request_data)
    end
  end
end
