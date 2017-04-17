require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }

    it 'returns http success when user logged in' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns 302 when user not logged in' do
      get :index
      expect(response).to have_http_status(302)
    end
  end
end
