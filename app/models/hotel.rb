class Hotel < ApplicationRecord
    geocoded_by :address
    after_validation :geocode, if: :address_changed?

    acts_as_mappable
end
