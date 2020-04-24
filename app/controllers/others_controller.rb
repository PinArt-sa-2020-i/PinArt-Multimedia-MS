class OthersController < ApplicationController

    def generateToken
        payload = {
            "unique_name": params[:idUsuario]
        }

        token = EncodeJwt.call(payload);        

        render  :json => {
                            token: token
                         }, 
                :status => 200
        return
    end

end