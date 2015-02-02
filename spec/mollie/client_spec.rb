require 'spec_helper'

describe Mollie::Client do

  let(:api_key) { "test_4drFuX5HdjBaFxdXoaABYD8yO4HjuT" }

  context '#prepare' do

    it "will setup the payment on mollie" do

      VCR.use_cassette('prepare_payment') do
        client = Mollie::Client.new(api_key)
        amount = 99.99
        description = "My fantastic product"
        redirect_url = "http://localhost:3000/payments/1/update"
        response = client.prepare_payment(amount, description, redirect_url, {:order_id => "R232454365"})

        expect(response["id"]).to eql "tr_ALc7B2h9UM"
        expect(response["mode"]).to eql "test"
        expect(response["status"]).to eql "open"
        expect(response["amount"]).to eql "99.99"
        expect(response["description"]).to eql description

        expect(response["metadata"]["order_id"]).to eql "R232454365"

        expect(response["links"]["paymentUrl"]).to eql "https://www.mollie.nl/payscreen/pay/ALc7B2h9UM"
        expect(response["links"]["redirectUrl"]).to eql redirect_url
      end
    end
  end

  context "issuers" do
    it "returns a hash with the iDeal issuers" do
      VCR.use_cassette('get_issuers_list') do
        client = Mollie::Client.new(api_key)
        response = client.issuers
        expect(response.first[:id]).to eql "ideal_TESTNL99"
        expect(response.first[:name]).to eql "TBM Bank"
      end
    end
  end

  context 'status' do
    context 'when payment is paid' do
      it "returns the paid status" do
        VCR.use_cassette('get_status_paid') do
          client = Mollie::Client.new(api_key)
          response = client.payment_status("tr_8NQDMOE7EC")
          expect(response["status"]).to eql "paid"
        end
      end
    end
  end

  context "refund" do
    it "refunds the payment" do
      VCR.use_cassette('refund payment') do
        client = Mollie::Client.new(api_key)
        response = client.refund_payment("tr_8NQDMOE7EC")
        expect(response["payment"]["status"]).to eql "refunded"
      end
    end
  end

  context 'payment_methods' do
    it 'returns a hash with payment methods' do
      VCR.use_cassette('get methods list') do
        client = Mollie::Client.new(api_key)
        response = client.payment_methods

        expect(response['totalCount']).to eql 8
        expect(response['data'].first['id']).to eql 'ideal'
        expect(response['data'].first['description']).to eql 'iDEAL'

        expect(response['data'].first['amount']['minimum']).to eql '0.55'
        expect(response['data'].first['amount']['maximum']).to eql '50000.00'

        expect(response['data'].first['image']['normal']).to eql 'https://www.mollie.com/images/payscreen/methods/ideal.png'
        expect(response['data'].first['image']['bigger']).to eql 'https://www.mollie.com/images/payscreen/methods/ideal@2x.png'
      end
    end

    it 'returns a hash for ideal method' do
      VCR.use_cassette('get ideal method') do

        client = Mollie::Client.new(api_key)
        response = client.payment_methods('ideal')

        expect(response['id']).to eql 'ideal'
        expect(response['description']).to eql 'iDEAL'

        expect(response['amount']['minimum']).to eql '0.55'
        expect(response['amount']['maximum']).to eql '50000.00'

        expect(response['image']['normal']).to eql 'https://www.mollie.com/images/payscreen/methods/ideal.png'
        expect(response['image']['bigger']).to eql 'https://www.mollie.com/images/payscreen/methods/ideal@2x.png'
      end
    end
  end

  context "error response" do
    it "will raise an Exception" do
      VCR.use_cassette('invalid_key') do
        client = Mollie::Client.new(api_key << "foo")
        response = client.refund_payment("tr_8NQDMOE7EC")
        expect(response["error"]).to_not be nil
      end
    end
  end

end
