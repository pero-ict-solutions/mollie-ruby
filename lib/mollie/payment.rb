require 'httparty'
require 'json'

module Mollie
  class Payment
    include HTTParty
    base_uri 'https://api.mollie.nl/v1'
    format :json
    attr_accessor :api_key

    def initialize(api_key)
      self.api_key = api_key
    end

    def auth_token
      "Bearer " + self.api_key
    end

    def prepare(amount, description, redirect_url, metadata = {})
      response = self.class.post('/payments',
        :body => {
          :amount => amount,
          :description => description,
          :redirectUrl => redirect_url,
          :metadata => metadata
        },
        :headers => {
          'Authorization' => auth_token
        }
      )
      JSON.parse(response.body)
    end

    def status(payment_id)
      response = self.class.get("/payments/#{payment_id}",
        :headers => {
          'Authorization' => auth_token
        }
      )
      JSON.parse(response.body)
    end

    def refund(payment_id)
      response = self.class.post("/payments/#{payment_id}/refunds",
        :headers => {
          'Authorization' => auth_token
        }
      )
      JSON.parse(response.body)
    end

  end
end
