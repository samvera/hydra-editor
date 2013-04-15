HydraEditor::Engine.routes.draw do
  resources :records, except: [:index]
end
