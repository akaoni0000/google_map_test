# README

google map表示はgoogle apiを取得　 https://qiita.com/tiara/items/4a1c98418917a0e74cbb

gem 'gmaps4rails'

application.htmlのheader
 <script src="//maps.google.com/maps/api/js?v=3.23&key=AIzaSyDZ_fP_4giVC4eWpMH6I_zaYZk9DC1SEY8"></script>
    <script src="//cdn.rawgit.com/mahnunchik/markerclustererplus/master/dist/markerclusterer.min.js"></script>
    <script src='//cdn.rawgit.com/printercu/google-maps-utility-library-v3-read-only/master/infobox/src/infobox_packed.js' type='text/javascript'></script> 


javascriptで
//= require gmaps/google

underscore.jsを書く





文字列の住所を緯度経度に換算
gem 'geocoder'

設定ファイルを作成
rails generate geocoder:config 

create_table "hotels", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"  ここの英語は変えてはけない
    t.float "longitude"　ここの英語は変えてはけない
  end

これでaddressを保存したとき自動でlatitudeに緯度　longitudeに経度が保存される

現在地の取得
https://syncer.jp/how-to-use-geolocation-api


経度緯度から2点の距離
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
        lat1 = 35.444991 #緯度
        lng1 = 139.636768 #経度
        lat2 = 35.523142
        lng2 = 139.708024
        @distance = GetDistance.distance(lat1, lng1, lat2, lng2).round(2)
    end
    @distanceはキロ



apiキーの作成
https://console.cloud.google.com/google/maps-apis/credentials?project=oceanic-hangout-279405
にアクセス

認証情報から
API とサービスの認証情報をクリックしてapiキーを発行する