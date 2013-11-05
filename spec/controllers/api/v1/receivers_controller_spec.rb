require 'spec_helper'

describe Api::V1::ReceiversController do
  describe '#create' do
    context 'with no params' do
      it 'is a bad request' do
        post :create
        expect(response).to be_bad_request
      end
    end

    context 'with valid device params' do
      let(:receiver) { FactoryGirl.build(:receiver) }
      let(:uid) { receiver.uid }
      let(:gcm_id) { receiver.gcm_id }

      let(:register_params) { { jwt: jwt,
                                uid: uid,
                                gcm_id: gcm_id } }

      before do
        allow(FetchOrBuildReceiver).to receive(:call).and_return(receiver)
        allow(WelcomeToPushSomething).to receive(:call)
      end

      context 'and a vaild JWT' do
        let(:found_user) { FactoryGirl.build(:user) }
        let(:jwt) { generate_jwt_token(found_user.email) }


        before do
          allow(User).to receive(:find_or_create_by_email).and_return(found_user)
        end

        after { post :create, register_params }

        it 'finds or creates a User' do
          expect(User).to receive(:find_or_create_by_email).with(found_user.email)
        end

        it 'finds or creates a Receiver' do
          expect(FetchOrBuildReceiver).to receive(:call).with(uid,
                                                              gcm_id,
                                                              found_user)
        end

        it 'welcomes the user and receiver to Push Something' do
          expect(WelcomeToPushSomething).to receive(:call).with(found_user,
                                                                receiver)
        end
      end

      context 'without valid a valid JWT' do
        render_views

        let(:jwt) { JWT.encode('wrongdecoding', 'wrongsecret') }

        before do
          post :create, register_params
          @body = JSON.parse(response.body)
        end

        it 'is unauthorized' do
          expect(response.code).to eq '401'
        end

        it 'is titled "Authorization Error"' do
          expect(@body['title']).to eq 'Authorization Error'
        end

        it 'contains a message of unable to parse JWT' do
          expect(@body['messages']).to include('Unable to parse JWT')
        end
      end
    end
  end

  def generate_jwt_token(email)
    payload = { iss: 'accounts.gogle.com',
                aud: ENV['GOOGLE_ID'],
                email: email }
    JWT.encode(payload, ENV['GOOGLE_SECRET'])
  end
end
