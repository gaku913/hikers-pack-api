class Api::V1::HelloController < ApplicationController
  def index
    msg = { id: 1, title: "greet", contents: "hello" }
    render json: msg
  end
end
