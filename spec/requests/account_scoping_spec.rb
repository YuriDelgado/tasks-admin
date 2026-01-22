require 'rails_helper'
describe "Account scoping", type: :request do
  let(:account_a) { create(:account) }
  let(:account_b) { create(:account) }

  let(:user_a) { create(:user, account: account_a, role: "parent") }
  let(:user_b) { create(:user, account: account_b, role: "parent") }

  let!(:activity_a) { create(:activity, account: account_a) }
  let!(:activity_b) { create(:activity, account: account_b) }

  before { sign_in user_a }

  it "cannot access another account's activity" do
    get api_activity_path(activity_b)

    expect(response).to have_http_status(:not_found)
  end
end
