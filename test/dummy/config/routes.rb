Rails.application.routes.draw do
  resources :companies do
    mega_scaffold :attachments,
      parent: -> (controller) { Company.find(controller.params[:company_id]) },
      collection: -> (controller) { controller.parent.attachments },
      fields: [
        { name: :id, view: :index },
        { name: :file, type: :file, view: :all, value: -> (record, context) { context.link_to 'Download', record.file.url } },
        { name: :created_at, view: :index },
      ]
  end

  namespace :secret do
    namespace :admin do
      mega_scaffold :categories, fields: [
        { name: :id, view: :index },
        { name: :name, type: :string, view: :all, value: -> (record, context) { record.name&.upcase } },
        { name: :accounts, view: [:index, :show], value: -> (record, context) { record.accounts.count } },
        { name: :created_at, view: [:index, :show], value: -> (record, context) { I18n.l record.created_at, format: :short } },
      ]
    end
  end

  mega_scaffold :users, collection: -> (controller) { User.ordered }

  mega_scaffold :photos, 
    fields: [
      { name: :user, column: :user_id, view: :all, type: :association, collection: -> { User.by_name }, value: -> (record, context) { record.user&.name } },
      { name: :photo, type: :file, view: :all, value: -> (record, context) { context.image_tag record.photo.url, style: 'width: 200px' } },
    ]

  mega_scaffold :accounts, 
    collection: -> (controller) { Account.by_name },
    fields: [
      { name: :id, view: [:index, :show] },
      { name: :name, type: :string, view: :all },
      { name: :categories, column: { category_ids: [] }, type: :association, as: :check_boxes, view: :form, collection: -> { Category.by_name }, value: { index: -> (record, context) { record.categories.count }, show: -> (record, context) { record.categories.pluck(:name).join(", ") } } },
      { name: 'VIRTUAL ATTR', type: :virtual, view: :index, value: -> (record, context) { context.link_to record.name.to_s.upcase, record } },
      { name: :owner, column: :owner_id, view: :all, type: :association, collection: -> { User.by_name }, value: -> (record, context) { record.owner&.name } },
      { name: :created_at, view: [:index, :show], value: -> (record, context) { I18n.l(record.created_at, format: :long) } },
    ]

  root "home#index"
end
