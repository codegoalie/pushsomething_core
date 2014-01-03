class ServicesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @service.update_attributes(params[:service])
      redirect_to services_path
    else
      render :edit
    end
  end

  def new
    @service = current_user.services.build
  end

  def create
    if @service.save
      redirect_to services_path
    else
      render :new
    end
  end

  def destroy
    @service.delete

    redirect_to services_path
  end
end