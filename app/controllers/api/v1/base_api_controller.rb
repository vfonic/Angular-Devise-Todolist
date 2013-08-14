class Api::V1::BaseApiController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_filter :skip_trackable

  protected
    def skip_trackable
      request.env['devise.skip_trackable'] = true
    end
end
