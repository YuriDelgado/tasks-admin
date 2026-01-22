require "rails_helper"

RSpec.describe "JWT revocation", type: :request do
  let!(:user) { create(:user, email: "admin@example.com", password: "123456", role: "parent") }
  let!(:activity) { create(:activity, user: user, status: "active") }

  let(:login_headers) do
    { "Content-Type" => "application/json" }
  end

  let(:auth_headers) do
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{jwt_token}"
    }
  end

  let(:logout_headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{jwt_token}"
    }
  end

  let(:jwt_token) do
    post "/api/login",
         params: {
           user: {
             email: user.email,
             password: "123456"
           }
         }.to_json,
         headers: login_headers

    response.headers["Authorization"].split.last
  end

  it "revokes the token on logout" do
    # 1️⃣ token works
    get "/api/tasks", headers: auth_headers
    expect(response).to have_http_status(:ok)

    # 2️⃣ logout WITH token
    delete "/api/logout", headers: logout_headers
    expect(response).to have_http_status(:no_content)
    # 3️⃣ same token must fail

    get "/api/tasks", headers: auth_headers
    expect(response).to have_http_status(:unauthorized)
  end
end
