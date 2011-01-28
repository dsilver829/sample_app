SampleApp::Application.routes.draw do
    match '/contact', :to => 'pages#content'
    match '/about', :to => 'pages#about'
    match '/help', :to => 'pages#help'

    root :to => 'pages#home'
end
