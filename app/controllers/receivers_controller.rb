class ReceiversController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @receiver.update_attributes(params[:receiver])
      flash[:success] = t('receiver.update.success', name: @receiver)
      redirect_to @receiver
    else
      render :edit
    end
  end
end
