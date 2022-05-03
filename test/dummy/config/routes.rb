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

  mega_scaffold :users,
    collection: -> (controller) { User.ordered },
    concerns: [Protected],
    only: [:id, :name, :age, :dob, :country, :created_at, :phone]

  mega_scaffold :photos,
    fields: [
      { name: :user, column: :user_id, view: :all, type: :select, collection: -> { User.by_name.map{|e| [e.name, e.id]} }, value: -> (record, context) { record.user&.name } },
      { name: :photo, type: :file_field, view: :all, value: -> (record, context) { context.image_tag record.photo.url, style: 'width: 200px' } },
    ]

  mega_scaffold :accounts, 
    collection: -> (controller) { controller.admin? ? Account.all : current_user.accounts },
    fields: [
      { name: :id, view: [:index, :show] },
      { name: :name, type: :text_field, view: :all },
      { 
        name: :categories,
        column: {
          name: :category_ids,
          permit: [],
          options: [:id, :name]
        },
        type: :collection_check_boxes,
        view: :form,
        collection: -> { Category.by_name },
        value: {
          index: -> (record, context) { record.categories.count },
          show: -> (record, context) { record.categories.pluck(:name).join(", ") }
        }
      },
      { name: 'VIRTUAL ATTR', type: :virtual, view: :index, value: -> (record, context) { context.link_to record.name.to_s.upcase, record } },
      {
        name: :owner,
        column: {
          name: :owner_id,
          options: {include_blank: true}
        },
        view: :all,
        type: :select,
        collection: -> { User.by_name.map{|e| [e.name, e.id]} },
        value: -> (record, context) { record.owner&.name }
      },
      { name: :created_at, view: [:index, :show], value: -> (record, context) { I18n.l(record.created_at, format: :long) } },
    ]

  root "home#index"
end
