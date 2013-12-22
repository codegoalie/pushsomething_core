object @notification

node :message do
  t 'invalid', scope: [:notification]
end

node :errors do
  @notification.errors.full_messages
end
