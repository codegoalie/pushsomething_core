class FacebookController < ApplicationController
  before_filter :initialize_notification

  def show
    render json: @fb.fetch
  end

  def create
    @fb.deliver_all

    flash[:notice] = t(:success, scope: [:facebook])
    redirect_to services_path
  end

  private

  def initialize_notification
    @fb = FacebookNotifier.new(current_user)
  end
end
