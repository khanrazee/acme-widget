module ControllerMacros
  def login_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
      user
    end
  end
  
  def login_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      admin = FactoryBot.create(:user, :admin)
      sign_in admin
      admin
    end
  end
end

RSpec.configure do |config|
  config.extend ControllerMacros, type: :controller
end
