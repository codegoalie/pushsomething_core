class FetchOrBuildReceiver
  def self.call(uid, gcm_id, user)
    receiver = Receiver.where(uid: uid,
                              user_id: user.id).first

    unless receiver
      receiver = Receiver.create(uid: uid,
                                 gcm_id: gcm_id,
                                 user_id: user.id)
    end

    receiver
  end
end
