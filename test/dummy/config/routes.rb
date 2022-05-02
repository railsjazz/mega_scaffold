Rails.application.routes.draw do
  namespace :secret do
    namespace :admin do
      mega_scaffold :categories, fields: [
        { name: :id, view: :index },
        { name: :name, type: :string, view: :all, value: -> (record) { record.name&.upcase } },
        { name: :created_at, view: :index, value: -> (record) { I18n.l record.created_at, format: :short } },
        { name: :accounts, view: :index, value: -> (record) { record.accounts.count } },
      ]
    end
  end

  mega_scaffold :users, collection: -> { User.ordered }

  mega_scaffold :accounts, 
    collection: -> { Account.by_name },
    fields: [
      { name: :id, view: [:index, :show] },
      { name: :name, type: :string, view: :all },
      { name: :categories, column: { category_ids: [] }, type: :association, as: :check_boxes, view: :form, collection: -> { Category.by_name }, value: { index: -> (record) { record.categories.count }, show: -> (record) { record.categories.pluck(:name).join(", ") } } },
      { name: 'VIRTUAL ATTR', type: :virtual, view: :index, value: -> (record) { record.name.to_s.upcase } },
      { name: :owner, column: :owner_id, view: :all, type: :association, collection: -> { User.by_name }, value: -> (record) { record.owner&.name } },
      { name: :created_at, view: [:index, :show], value: -> (record) { I18n.l(record.created_at, format: :long) } },
    ]

  root "home#index"
end
