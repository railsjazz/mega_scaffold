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

  it 'creates records' do
    post '/accounts', params: { account: { name: 'ABC123', owner_id: @user.id } }
    expect(response).to be_redirect
    expect(Account.find_by(name: 'ABC123')).to be

    post '/accounts', params: { account: { name: '' } }
    expect(response.status).to eq(422)
  end

  it 'updates records' do
    expect(@account.name).to eq("soft")
    patch "/accounts/#{@account.id}", params: { account: { name: 'ABC123', owner_id: @user.id } }
    expect(response).to be_redirect
    @account.reload
    expect(@account.name).to eq("ABC123")

    patch "/accounts/#{@account.id}", params: { account: { name: '' } }
    expect(response.status).to eq(422)
  end

  it 'deleted the record' do
    delete "/accounts/#{@account.id}"
    expect(response).to be_redirect
    expect(Account.find_by(id: @account.id)).to be_nil
  end

  it 'saves with underscore record' do
    post "/export_lists", params: { export_list: { name: "name", account_id: 42 } }
    expect(response).to be_redirect
    expect(ExportList.first.account_id).to eq(42)
  end  

end