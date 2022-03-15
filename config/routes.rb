Rails.application.routes.draw do
  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout" => "sessions#destroy"
  
  resources :events do 
    resources :tickets
  end

  resource :retirements

  # どのルーティング設定にも当てはまらないリクエストが来た場合に、error404アクションを実行するように設定を追加しました。これにより、適当なURLをブラウザに入力すると「ご指定になったページは存在しません」と表示されるようになりました
  match "*path" => "application#error404", via: :all
end
