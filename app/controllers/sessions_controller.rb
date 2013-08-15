class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :json => current_user.to_json, status: :ok
  end

  def destroy
    super
  end

  def failure
    render :json => {:success => false, :error => "Invalid username/password combination" }
  end
end
