require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  let!(:user) do
    User.create!(
      email: "test@gmail.com",
      password: "password123!",
      password_confirmation: "password123!"
    ).tap(&:confirm)  # confirms the email so Devise allows login
  end

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "logs in successfully and redirects to root" do
        post user_session_path, params: {
          user: { email: user.email, password: "password123!" }
        }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      context "when password is wrong" do
        it "returns an error message" do
          post user_session_path, params: {
            user: { email: user.email, password: "wrong_password" }
          }

          expect(response.body).to include("Invalid email or password")
        end
      end

      context "when email does not exist" do
        it "returns an error message" do
          post user_session_path, params: {
            user: { email: "fake@example.com", password: "Password1!" }
          }

          expect(response.body).to include("Invalid email or password")
        end
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "logs out the user and redirects to root" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end