require 'spec_helper'

describe Mollie::Payment do

  context '#prepare' do

    it "will setup the payment on mollie" do

      VCR.use_cassette('prepare_payment') do
        payment = Mollie::Payment.new("test_NvvGesXLb61BFPvndsxzfqFBAqYmKN")
        amount = 99.99
        description = "My fantastic product"
        redirect_url = "http://localhost:3000/payments/1/update"
        response = payment.prepare(amount, description, redirect_url)

        expect(response["id"]).to eql "tr_FnFhEkdA9B"
        expect(response["mode"]).to eql "test"
        expect(response["status"]).to eql "open"
        expect(response["amount"]).to eql "99.99"
        expect(response["description"]).to eql description

        expect(response["links"]["paymentUrl"]).to eql "https://www.mollie.nl/payscreen/pay/FnFhEkdA9B"
        expect(response["links"]["redirectUrl"]).to eql redirect_url
      end
    end
  end

  context 'status' do
    context 'when payment is paid' do
      it "returns the paid status" do
        VCR.use_cassette('get_status_paid') do
          payment = Mollie::Payment.new("test_NvvGesXLb61BFPvndsxzfqFBAqYmKN")
          response = payment.status("tr_8DVABUHXn8")
          expect(response["status"]).to eql "paid"
        end
      end
    end
  end
end