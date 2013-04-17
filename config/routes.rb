HydraEditor::Engine.routes.draw do
  resources :records, except: [:index], :constraints => { :id => /[a-zA-Z0-9.:]+/ }

end
