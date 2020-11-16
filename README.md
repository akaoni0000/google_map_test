## 概要
googlemapを使った練習用のアプリです。

## バージョン
ruby・・・2.5.7<br>
rails・・・5.2.4.4<br>
nginx・・・1.19.3<br>
mysql・・・5.7

## ローカル環境での実行手順
dockerとdocker-composeを自分のpcにインストール

好きなディレクトリで<br>
`git clone https://github.com/Mac0917/googlemap.git`

移動<br>
`cd googlemap`

docker-composeを実行<br>
`docker-compose up -d`

データベース作成<br>
`docker exec -it goolemap_app_1 bash`(コンテナに入る)<br>
`rails db:create`<br>
`rails db:migrate`<br>

アクセス<br>
http://localhost/<br>
googlemap APIを取得してないのでエラーがでます。もしgoolemapを表示したいのなら下の見出しを読んで実装してみてください。



終了<br>
`exit`(コンテナから出る)<br>
`docker-compose stop`<br>
`docker-compose rm`<br>
`docker rmi googlemap-advance_app googlemap-advance_web`<br>
`docker volume rm googlemap_db-data googlemap_public-data googlemap_tmp-data`

リポジトリを削除<br>
`cd ..`<br>
`rm -rf googlemap`

## googlemapを表示させるまで
google apiを取得<br>
参考記事・・・https://qiita.com/tiara/items/4a1c98418917a0e74cbb<br>

`gem 'gmaps4rails'`<br>
`bundle install`<br>

application.htmlのheaderに以下を追加<br>
```
  <script src="//maps.google.com/maps/api/js?v=3.23&key=AIzaSyDZ_fP_4giVC4eWpMH6I_zaYZk9DC1SEY8"></script>
  <script src="//cdn.rawgit.com/mahnunchik/markerclustererplus/master/dist/markerclusterer.min.js"></script>
  <script src='//cdn.rawgit.com/printercu/google-maps-utility-library-v3-read-only/master/infobox/src/infobox_packed.js' type='text/javascript'></script> 
```

<br>
application.jsに以下を追加<br>
```
  //= require gmaps/google
```

underscore.jsを記述 ファイル参照<br>

viewを記述<br>
```
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
          "infowindow": "渋谷"
        }
      ]);
      handler.bounds.extendWith(markers);
      handler.fitMapToBounds();
      handler.getMap().setZoom(16);
    });
  </script>
```


## 文字列の住所を緯度経度に換算 apiを使用しないとき (精度低い)
`gem 'geocoder'`<br>
`bundle install`<br>

カラムを追加<br>
```
  create_table "hotels", force: :cascade do |t|
      t.string "address"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.float "latitude"  #ここの英語は変えてはけない
      t.float "longitude"　#ここの英語は変えてはけない
  end
```

モデル.rbファイルに以下を記述<br>
```
  class Hotel < ApplicationRecord
    geocoded_by :address  #カラム名
    after_validation :geocode, if: :address_changed?
    #addressが保存されたり変更されたら緯度経度を保存する
      # acts_as_mappable
  end
```

apiを使った時は自動で保存されない<br>
apiではjsで正確な緯度経度をだしてくれる<br>


## 文字列の住所を緯度経度に換算 apiを使用するとき (精度高い)
`gem 'geocoder'`<br>
`bundle install`<br>

カラムを追加<br>
```
create_table "hotels", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"  #ここの英語は変えてはけない
    t.float "longitude"　#ここの英語は変えてはけない
end
```

Geocoding APIを取得<br>
application.htmlに以下を追加
```
<script src="//maps.google.com/maps/api/js?v=3.23&key=公開鍵"></script>
```

設定ファイルを作成<br>
`rails generate geocoder:config`<br>
geocoder.rbが作成される<br>
詳細はgeocoder.rbを見る<br>

これでaddressを保存したとき自動でlatitudeに緯度　longitudeに経度が保存される<br>

## 現在地の取得
参考・・・https://syncer.jp/how-to-use-geolocation-api<br>
application.jsのファイルを参照


## 経度緯度から2点の距離をだす
```
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

```
    
## apiキーの作成
https://console.cloud.google.com/google/maps-apis/credentials<br>
にアクセス<br>

認証情報からAPIとサービスの認証情報をクリックしてapiキーを発行する


## 追記
apiキーの設定でhttpリファラーしなくてもしてもできた<br>
本番環境ではssl化しないと現在地は取得できない
