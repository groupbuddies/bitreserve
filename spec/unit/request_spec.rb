# frozen_string_literal: true

require 'spec_helper'

module Uphold
  shared_examples 'perform request method' do |method_name|
    let(:object_class) { double('ObjectClass', new: nil, from_collection: nil) }
    let(:response) { double('Response', code: 200, parsed_response: '', headers: {}) }
    let(:request) { spy('request', get: response, post: response) }
    let(:client) { Client.new }

    context ".#{method_name}" do
      it 'makes the correct call for a GET' do
        allow(Request).to receive(:new).and_return(request)

        Request.public_send(method_name, :get, request_data)

        expect(request).to have_received(:get)
      end

      it 'makes the correct call for a POST' do
        allow(Request).to receive(:new).and_return(request)

        Request.public_send(method_name, :post, request_data)

        expect(request).to have_received(:post)
      end

      it 'makes the actual GET call' do
        url = '/some-url'
        WebMockHelpers.uphold_stub_request(:get, url)
        allow(Request).to receive(:get).and_call_original

        Request.public_send(method_name, :get, request_data(url, client))

        expect(Request).to have_received(:get).with(url, headers: client.authorization_header)
      end

      it 'makes the actual POST call' do
        url = '/some-url'
        data = { key: 'value' }
        WebMockHelpers.uphold_stub_request(:post, url)
        allow(Request).to receive(:post).and_call_original

        Request.public_send(method_name, :post, request_data(url, client, data))

        expect(Request).to have_received(:post).with(url, body: data, headers: client.authorization_header)
      end

      it 'makes a call with basic auth' do
        url = '/some-url'
        headers = { header1: 'I am a header' }
        body = { description: 'whatever' }
        request_data = RequestData.new(url, object_class, headers, body)
        WebMockHelpers.uphold_stub_request(:get, url)
        allow(Request).to receive(:get).and_call_original

        Request.public_send(method_name, :get, request_data)

        expect(Request).to have_received(:get).with(url, headers: headers, body: body)
      end

      it 'handles an auth error response' do
        fake_error = { code: '401', error: 'invalid_token', error_description: 'A description' }
        request_data = RequestData.new('/some-url', object_class)
        WebMockHelpers.uphold_stub_request(:get, '/some-url', fake_error, status: 401)

        result = Request.public_send(method_name, :get, request_data)

        expect(result).to be_a(Entities::OAuthError)
        expect(result.code).to eq '401'
      end

      it 'handles an error response' do
        fake_error = { code: '400', errors: {} }
        request_data = RequestData.new('/some-url', object_class)
        WebMockHelpers.uphold_stub_request(:get, '/some-url', fake_error, status: 400)

        result = Request.public_send(method_name, :get, request_data)

        expect(result).to be_a(Entities::Error)
        expect(result.code).to eq '400'
      end
    end

    def request_data(url = anything, client = nil, payload = nil)
      client ||= double('Client', authorization_header: {})
      RequestData.new(url, object_class, client.authorization_header, payload)
    end
  end

  describe Request do
    include_examples 'perform request method', :perform_with_object
    include_examples 'perform request method', :perform_with_objects
  end
end
