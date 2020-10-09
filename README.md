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

<h1>google map</h1>
<div style='width: 800px;'>
  <div id="map" style='width: 800px; height: 400px;'></div>
</div>

<script type="text/javascript">
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers([
      {
        "lat": "<%= @lat %>", //緯度
        "lng": "<%= @lng %>", //経度
        "infowindow": "テックキャンプ渋谷オフィス"
      }
    ]);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(16);
  });
</script>





文字列の住所を緯度経度に換算
gem 'geocoder'

rbファイルに
class Hotel < ApplicationRecord
    geocoded_by :address
    after_validation :geocode, if: :address_changed?
    #addressが保存されたり変更されたら緯度経度を保存する
    # acts_as_mappable
end
apiを使った時は自動で保存されなかった
apiではjsで正確な緯度経度をだしてくれる


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
jsに書いてある

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








geocoderの精度をあげるには
Geocoding APIを取得
application.html
<script src="//maps.google.com/maps/api/js?v=3.23&key=AIzaSyAvHs9f3DrpaQXU20q672klP11qzHgn4WY"></script>
これだけでいい

config/geocoder.rbに
Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  #lookup: :google,         # name of geocoding service (symbol)
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  language: :ja,              # ISO-639 language code
  use_https: true,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  #api_key:"AIzaSyDZ_fP_4giVC4eWpMH6I_zaYZk9DC1SEY8"# API key for geocoding service


  api_key:"AIzaSyAvHs9f3DrpaQXU20q672klP11qzHgn4WY"
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)

apiキーの設定でhttpリファラーしなくてもしてもできた


ssl化けしないと現在地は取得できない
