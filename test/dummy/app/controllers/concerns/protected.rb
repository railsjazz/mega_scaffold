module Protected
  extend ActiveSupport::Concern
 
  included do
    http_basic_authenticate_with name: "user", password: "secret"
  end

end
