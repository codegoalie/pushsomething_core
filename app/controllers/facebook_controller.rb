class FacebookController < ApplicationController
  before_filter :initialize_notification

  def show
    render json: @fb.fetch
  end

  def fetch
    @fb.deliver
  end

  private

  def initialize_notification
    @fb = FacebookNotifier.new(current_user)
  end
end
