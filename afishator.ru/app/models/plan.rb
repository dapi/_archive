class Plan
  include Mongoid::Document

  field :date, type: Date
  field :time, type: Time
  # field :period

  # index :date
  # index :time

  embedded_in :event
end

