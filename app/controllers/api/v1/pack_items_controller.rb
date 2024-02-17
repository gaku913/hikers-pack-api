class Api::V1::PackItemsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_pack
  before_action :set_pack_item, only: [:show, :update, :destroy]
  after_action :destroy_unused_items, only: [:update, :destroy]

  def index
    @pack_items = @pack.pack_items
    render json: @pack_items.includes(:item).to_json(
      only: [:id, :quantity, :checked],
      include: { item: { only: [:name, :weight] } }
    )
  end

  def show
    render json: @pack_item.to_json(
      only: [:id, :quantity, :checked],
      include: { item: { only: [:name, :weight] } }
    )
  end

  def create
    # 既存のitemに該当がなければ作成
    item = current_api_v1_user.items.find_or_create_by(item_params)
    # pack_itemに属性とitemの紐づけを設定
    @pack_item = @pack.pack_items.build(pack_item_params.merge(item: item))

    if @pack_item.save
      render json: @pack_item, status: :created
    else
      render json: @pack_item.errors, status: :unprocessable_entity
    end
  end

  def update
    # 既存のitemに該当がなければ作成
    item = current_api_v1_user.items.find_or_create_by(updated_item_params)

    # pack_itemの属性とitemの紐づけを更新
    if @pack_item.update(pack_item_params.merge(item: item))
      render json: @pack_item
    else
      render json: @pack_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @pack_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pack
    @pack = current_api_v1_user.packs.find(params[:pack_id])
  end

  def set_pack_item
    @pack_item = @pack.pack_items.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pack_item_params
    params.require(:pack_item).permit(:quantity, :checked)
  end

  def item_params
    params.require(:pack_item).permit(item: [:name, :weight])[:item]
  end

  # 現在のitemの属性にitem_paramsをマージする
  def updated_item_params
    current_item_attributes = @pack_item.item.attributes
    current_item_params = ActionController::Parameters.new(current_item_attributes)
    current_item_params.merge(item_params).permit(:name, :weight)
  end

  # PackItemに紐づいていないItemレコードを削除する
  def destroy_unused_items
    current_api_v1_user.items
      .left_outer_joins(:pack_items)
      .where(pack_items: { id: nil })
      .destroy_all
  end
end
