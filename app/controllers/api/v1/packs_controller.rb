class Api::V1::PacksController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    packs = current_api_v1_user.packs.order(start_date: :desc)
    render json: packs
  end

  def show
    pack = current_api_v1_user.packs.find(params[:id])
    render json: pack
  end

  def create
    pack = current_api_v1_user.packs.new(pack_params)
    if pack.save
      render json: {status: "SUCCESS", message: "Saved article", data: pack}, status: :created
    else
      render json: {status: "ERROR", message: "Pack not saved", data: pack.errors}, status: :unprocessable_entity
    end
  end

  def update
    pack = current_api_v1_user.packs.find(params[:id])
    if pack.update(pack_params)
      render json: {status: "SUCCESS", message: "Updated article", data: pack}, status: :ok
    else
      render json: {status: "ERROR", message: "Pack not updated", data: pack.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    pack = current_api_v1_user.packs.find(params[:id])
    pack.destroy
    render json: {status: "SECCESS", message: "Deleted pack", data: pack}, status: :ok
  end

  private

  def pack_params
    params.require(:pack).permit(:title, :memo, :start_date, :end_date)
  end
end
