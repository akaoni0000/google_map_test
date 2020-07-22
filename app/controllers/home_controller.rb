class HomeController < ApplicationController

    def top
        @hotel = Hotel.new
    end

    def create
        @hotel.new(hotel_params)
        @hotel.save
    end
end
