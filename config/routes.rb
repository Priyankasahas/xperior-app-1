Rails.application.routes.draw do
  root to: 'welcome#index'

  api_version module: 'V1',
              header: { name: 'Accept', value: 'application/vnd.xperior.com; version=1' },
              default: true do
    resources :authentication, only: :create
    resources :users
  end
end
