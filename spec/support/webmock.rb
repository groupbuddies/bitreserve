# frozen_string_literal: true

require 'webmock/rspec'
require 'uri'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

module WebMockHelpers
  def self.uphold_stub_request(method, url, response = [], status: 200)
    WebMock::API.stub_request(method, Uphold::Request.base_uri + url).
      to_return(body: response.to_json, status: status, headers: { 'Content-Type' => 'application/json' })
  end
end
