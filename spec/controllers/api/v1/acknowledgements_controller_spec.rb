# encoding: utf-8

require 'spec_helper'

describe Api::V1::AcknowledgementsController do
  describe '#create' do
    let(:uid) { 'existing_uid' }
    let(:auth_token) { 'valid_token' }
    let(:receiver) { FactoryGirl.build(:receiver,
                                       auth_token: 'valid_token',
                                       uid: 'existing_uid') }
    let(:notification) { FactoryGirl.build(:notification) }

    before do
      allow(Receiver).to receive(:where).with(uid: uid)
                                        .and_return([receiver])
      Notification.stub_chain(:find_for_user)
                  .and_return(notification)
      Notification.any_instance
                  .stub(:acknowledge!)
                  .and_return(true)
    end

    context do
      after do
        post :create, uid: uid,
          auth_token: auth_token,
          notification_id: notification.id,
          format: :json
      end

      it 'finds the receiver' do
        expect(Receiver).to receive(:where).with(uid: receiver.uid)
      end

      it 'finds the notification' do
        expect(Notification).to receive(:find_for_user).with(receiver.user,
                                                             notification.id)
      end

      it 'acknowledges the notification' do
        expect(notification).to receive(:acknowledge!).with(receiver)
      end
    end

    context 'without a valid API token' do
      let(:auth_token) { 'invalid_token' }

      before do
        post :create, uid: uid,
          auth_token: auth_token,
          notification_id: notification.id,
          format: :json
      end

      it 'returns unauthorized'  do
        expect(response.code).to eq '401'
      end
    end
  end
end
