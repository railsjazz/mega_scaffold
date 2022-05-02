Rails.application.routes.draw do
  namespace :secret do
    namespace :admin do
      mega_scaffold :categories, fields: [
        { name: :name, type: :string, view: :all, value: -> (record) { record.name&.upcase } },
      ]
    end
  end

  mega_scaffold :users, collection: -> { User.ordered }

  mega_scaffold :accounts, 
    collection: -> { Account.by_name },
    fields: [
      { name: :id, view: [:index, :show] },
      { name: :name, type: :string, view: :all },
      { name: 'VIRTUAL ATTRIBUTE', type: :virtual, view: :index, value: -> (record) { record.name.to_s.upcase } },
      { name: :owner, column: :owner_id, view: :all, type: :association, collection: -> { User.all }, value: -> (record) { record.owner&.name } },
      { name: :created_at, view: [:index, :show], value: -> (record) { I18n.l(record.created_at, format: :long) } },
    ]

  root "home#index"
end
