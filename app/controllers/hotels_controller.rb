class HotelsController < ApplicationController
    def new 
        Hotel.find(:all, :origin =>[35.339297,136.055422], :within=>10) 
    end
end
