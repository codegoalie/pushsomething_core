class ReceiversController < ApplicationController

  def index
    @receivers = Receiver.all
  end
end
