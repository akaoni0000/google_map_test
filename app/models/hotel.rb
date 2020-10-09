class Hotel < ApplicationRecord
    geocoded_by :address
    after_validation :geocode, if: :address_changed?
    #addressが保存されたり変更されたら緯度経度を保存する
    # acts_as_mappable
end
