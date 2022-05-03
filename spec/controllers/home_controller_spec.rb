require_relative "../rails_helper"

describe "Pages", type: :request do
  before do
    @user = User.create!(name: "john")
    @account = Account.create!(name: "soft", owner: @user)
    @company = Company.create!(name: "company")
    @category = Category.create!(name: "category")
  end

  it "works" do
    [
      '/',
      "/companies/#{@company.id}",
      "/companies/#{@company.id}/edit",
      "/companies/#{@company.id}/attachments",
      "/companies/#{@company.id}/attachments/new",
      '/accounts',
      '/accounts/new',
      "/accounts/#{@account.id}",
      "/accounts/#{@account.id}/edit",
      '/secret/admin/categories',
      '/secret/admin/categories/new',
      "/secret/admin/categories/#{@category.id}",
      "/secret/admin/categories/#{@category.id}/edit",
      '/photos', 
    ].each do |url|
      get url
      expect(response).to be_successful
    end
  end


  it 'with protection' do
    [
      '/users',
      '/users/new',
      "/users/#{@user.id}",
      "/users/#{@user.id}/edit",
    ].each do |url|
      get url, headers: { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials('user', 'secret') }
      expect(response).to be_successful
    end
  end

end