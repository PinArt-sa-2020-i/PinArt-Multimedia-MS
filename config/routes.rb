Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #MUltimedia
  post '/multimedia/add', to:'multimedia#add', as: "addMultimedia"
  
  delete '/multimedia/delete/:id', to:"multimedia#delete", as: "deleteMultimedia"

  put '/multimedia/update', to:'multimedia#update', as: "updateMultimedia"

  delete '/multimedia/deleteEtiqueta/:id/:idEtiqueta', to:"multimedia#deleteEtiqueta", as: "deleteEtiquetaMultimedia"

  put '/multimedia/addEtiqueta', to:"multimedia#addEtiqueta", as: "addEtiquetaMultimedia"

  
  #Tablero
  post '/tablero/addMultimedia', to:"tablero#addMultimedia", as: "addMultimediaTablero"

  delete '/tablero/deleteMultimedia/:idTablero/:idMultimedia', to:"tablero#deleteMultimedia", as: "deleteMultimediaTablero"

  delete '/tablero/delete/:id', to:'tablero#delete', as: "deleteTablero"

  #Usuario
  delete '/usuario/delete/:id', to:'usuario#delete', as: "deleteUsuario"

  #Etiquetas
  delete '/etiqueta/delete/:id', to: "etiqueta#delete", as: "deleteEtiqueta"

  #Other
  post '/others/generateToken', to: "others#generateToken", as: "generateToken"
end
