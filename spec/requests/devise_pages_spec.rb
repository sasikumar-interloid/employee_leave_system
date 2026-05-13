require 'rails_helper'

RSpec.describe "DevisePages", type: :request do
  describe "GET /devise_pages" do
    it "loads the login page" do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end

    it "loads the signup page" do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it "loads the forget password page" do
      get new_user_password_path
      expect(response).to have_http_status(:ok)
    end

    it "loads the resend confirmation page" do
      get new_user_confirmation_path
      expect(response).to have_http_status(:ok)
    end

    it "loads the unlock instructions page" do
      get new_user_unlock_path
      expect(response).to have_http_status(:ok)
    end
  end
end
