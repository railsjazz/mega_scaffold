Rails.application.routes.draw do
  mega_scaffold :users
  mega_scaffold :accounts, fields: [
    { name: :id, view: [:index, :show] },
    { name: :name, type: :string, view: :all },
    { name: 'VIRTUAL ATTRIBUTE', type: :virtual, view: :index, value: -> (record) { record.name.to_s.upcase } },
    { name: :owner, column: :owner_id, view: :all, type: :association, collection: -> { User.all }, value: -> (value) { value.name } },
    { name: :created_at, view: [:index, :show], value: -> (value) { I18n.l(value, format: :long) } },
  ]

  root "home#index"
end
