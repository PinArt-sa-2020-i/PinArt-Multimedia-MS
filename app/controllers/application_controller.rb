class ApplicationController < ActionController::API

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            @decoded = DecodeJwt.call(header)
            @current_user = @decoded[:unique_name]
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end
end
