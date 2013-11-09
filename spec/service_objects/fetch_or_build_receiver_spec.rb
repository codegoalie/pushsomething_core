require 'spec_helper'

describe FetchOrBuildReceiver do
  let(:user) { FactoryGirl.build(:user) }
  let(:uid) { '12345' }
  let(:gcm_id) { '54321' }

  describe '.call'  do
    before do
      allow(Receiver).to receive(:where).with(uid: uid, user_id: user.id)
                                         .and_return([found_receiver])
    end

    context 'when a receiver for the user with the UID exists' do
      let(:found_receiver) { FactoryGirl.build(:receiver) }

      it 'returns the existing reciever' do
        expect(FetchOrBuildReceiver.call(uid, gcm_id, user)).to be found_receiver
      end

      it 'does not create a new receiver' do
        expect(Receiver).not_to receive(:create)
        FetchOrBuildReceiver.call(uid, gcm_id, user)
      end
    end
  end

  context 'when a receiver for the user with the UID does not exist' do
    let(:found_receiver) { nil }

    it 'creates a new receiver' do
      expect(Receiver).to receive(:create).with(uid: uid,
                                                gcm_id: gcm_id,
                                                user_id: user.id)
        FetchOrBuildReceiver.call(uid, gcm_id, user)
    end
  end
end
