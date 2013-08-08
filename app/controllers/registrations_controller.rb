class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.save
      sign_up(resource_name, resource)
      render json: resource, status: 200
    else
      clean_up_passwords resource
      render json: resource, status: 401
    end
  end
end
