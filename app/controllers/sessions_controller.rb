class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :json => current_user.to_json
  end

  def failure
    render :json => {:success => false, :errors => ["Login Failed"]}
  end
end
