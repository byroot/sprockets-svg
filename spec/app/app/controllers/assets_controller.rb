class AssetsController < ApplicationController

  def test
    asset = Rails.application.assets[params[:file]]
    send_data asset.to_s, content_type: asset.content_type
  end

end
