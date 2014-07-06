class FacebookController < ApplicationController
  def show
    @fb = FacebookNotifier.new(current_user)
    render json: @fb.fetch
  end

  def create
    FacebookWorker.perform_async(current_user.id)

    flash[:notice] = t(:success, scope: [:facebook])
    redirect_to services_path
  end
end
