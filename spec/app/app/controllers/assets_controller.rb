class AssetsController < ApplicationController

  def test
    render text: Rails.application.assets[params[:file]].to_s
  end

end
