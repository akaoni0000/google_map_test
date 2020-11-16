class HomeController < ApplicationController

    module GetDistance

        def self.distance(lat1, lng1, lat2, lng2)
          # ラジアン単位に変換
          x1 = lat1.to_f * Math::PI / 180
          y1 = lng1.to_f * Math::PI / 180
          x2 = lat2.to_f * Math::PI / 180
          y2 = lng2.to_f * Math::PI / 180
     
          # 地球の半径 (km)
          radius = 6378.137
     
          # 差の絶対値
          diff_y = (y1 - y2).abs
     
          calc1 = Math.cos(x2) * Math.sin(diff_y)
          calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
     
          # 分子
          numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
     
          # 分母
          denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
     
          # 弧度
          degree = Math.atan2(numerator, denominator)
     
          # 大円距離 (km)
          degree * radius
        end
     
    end 

    def top
        @hotel = Hotel.new
        #Hotel.within(5, origin: [33.33, 140.33])
        @hot = Hotel.last
        if @hot.blank?
            @lat = 35
            @lng = 139
        else
            @lat = @hot.latitude
            @lng = @hot.longitude
        end
        # @lat = @hot.latitude
        # @lng = @hot.longitude
        #Hotel.find(3).(:all, :origin =>[35.339297,136.055422], :within=>10) 
        #Hotel.in_range(2..5, origin: [33.33, 140.33]) 

        #このようにして２点間の距離もだせる
        lat1 = 35.444991 #緯度
        lng1 = 139.636768 #経度
        lat2 = 35.523142
        lng2 = 139.708024
        @distance = GetDistance.distance(lat1, lng1, lat2, lng2).round(2)
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
