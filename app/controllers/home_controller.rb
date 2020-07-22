class HomeController < ApplicationController

    def top
        @hotel = Hotel.new
        
    end

    def create
        @hotel = Hotel.new(hotel_params)
        @hotel.save
        redirect_to root_path
    end

    private
    def hotel_params
        params.require(:hotel).permit(:address)
    end
end
