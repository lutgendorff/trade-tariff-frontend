TradeTariffFrontend::Application.routes.draw do
  scope :path => "#{APP_SLUG}" do
    get "/" => "pages#index"
    match "/search" => "search#search", via: :get, as: :perform_search
    match "/change-date" => "change_date#change", via: :get, as: :change_date

    resources :sections, only: [:index, :show]
    resources :chapters, only: [:index, :show]
    resources :headings, only: [:index, :show]
    resources :commodities, only: [:index, :show]
  end

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
