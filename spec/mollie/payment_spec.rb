require 'spec_helper'

describe Mollie::Payment do

  let(:api_key) { "test_6zjmE6z9SRyzUs7hRbl7AY6MU5jFoW" }

  context '#prepare' do

    it "will setup the payment on mollie" do

      VCR.use_cassette('prepare_payment') do
        payment = Mollie::Payment.new(api_key)
        amount = 99.99
        description = "My fantastic product"
        redirect_url = "http://localhost:3000/payments/1/update"
        response = payment.prepare(amount, description, redirect_url)

        expect(response["id"]).to eql "tr_8NQDMOE7EC"
        expect(response["mode"]).to eql "test"
        expect(response["status"]).to eql "open"
        expect(response["amount"]).to eql "99.99"
        expect(response["description"]).to eql description

        expect(response["links"]["paymentUrl"]).to eql "https://www.mollie.nl/payscreen/pay/8NQDMOE7EC"
        expect(response["links"]["redirectUrl"]).to eql redirect_url
      end
    end
  end

  context 'status' do
    context 'when payment is paid' do
      it "returns the paid status" do
        VCR.use_cassette('get_status_paid') do
          payment = Mollie::Payment.new(api_key)
          response = payment.status("tr_8NQDMOE7EC")
          expect(response["status"]).to eql "paid"
        end
      end
    end
  end
end
