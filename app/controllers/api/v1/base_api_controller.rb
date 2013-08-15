class Api::V1::BaseApiController < ApplicationController
  respond_to :json

  before_filter :skip_trackable

  protected
    def skip_trackable
      request.env['devise.skip_trackable'] = true
    end
end
