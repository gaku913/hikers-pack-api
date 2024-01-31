class Api::V1::Auth::SessionsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    render json: current_api_v1_user
  end
end
