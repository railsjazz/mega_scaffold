Rails.application.routes.draw do
  resources :companies do
    mega_scaffold :attachments,
      parent: -> (controller) { Company.find(controller.params[:company_id]) },
      collection: -> (controller) { controller.parent.attachments },
      fields: [
        { name: :id, view: :index },
        { name: :file, type: :file_field, view: :all, value: -> (record, view) { view.link_to 'Download', record.file.url } },
        { name: :created_at, view: :index },
      ]
  end

  namespace :secret do
    namespace :admin do
      mega_scaffold :categories, fields: [
        { name: :id, view: :index },
        { name: :name, view: :all, value: -> (record, _) { record.name&.upcase } },
        { name: :accounts, view: [:index, :show], value: -> (record, _) { record.accounts.count } },
        { name: :created_at, view: [:index, :show], value: -> (record, _) { I18n.l record.created_at, format: :short } },
      ]
    end
  end

  mega_scaffold :users,
    collection: -> (_) { User.ordered },
    concerns: [Protected],
    only: [:id, :name, :age, :dob, :country, :created_at, :phone]

  mega_scaffold :photos,
    fields: [
      { name: :user, column: :user_id, view: :all, type: :select, collection: -> { User.by_name.map{|e| [e.name, e.id]} }, value: -> (record, view) { view.link_to_if record.user, record.user&.name, record.user } },
      { name: :photo, type: :file_field, view: :all, value: -> (record, view) { view.image_tag record.photo.url, style: 'width: 200px' } },
      { name: :created_at, view: :index, value: -> (record, view) { view.l record.created_at, format: :long } },
    ]

  mega_scaffold :accounts, 
    collection: -> (controller) { controller.admin? ? Account.all : current_user.accounts },
    fields: [
      { name: :id, view: [:show] },
      { name: :name, type: :text_field, view: :all, value: -> (record, view) { view.link_to record.name.to_s.upcase, record } },
      {
        view: :all,
        name: :account_type,
        type: :collection_select,
        collection: -> { Account::TYPES },
        options: [:to_s, :to_s, include_blank: true]
      },
      {
        view: :all,
        name: :priority,
        type: :range_field,
        options: { min: 0, max: 100, step: 10 }
      },
      { 
        name: :categories,
        column: {
          name: :category_ids,
          permit: [],
        },
        type: :collection_check_boxes,
        options: [:id, :name],
        view: :form,
        collection: -> { Category.by_name },
        value: {
          index: -> (record, _) { record.categories.count },
          show: -> (record, _) { record.categories.pluck(:name).join(", ") }
        }
      },
      { name: 'VIRTUAL ATTR', type: :virtual, view: :index, value: -> (record, view) { "ID: #{record.id}" } },
      {
        name: :owner_id,
        label: "Owner",
        view: :all,
        options: { include_blank: true },
        type: :select,
        collection: -> { User.by_name.map{|e| [e.name, e.id]} },
        value: -> (record, _) { record.owner&.name }
      },
      { name: :created_at, view: [:index, :show], value: -> (record, _) { I18n.l(record.created_at, format: :long) } },
    ]

  root "home#index"
end
