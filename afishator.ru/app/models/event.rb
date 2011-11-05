class Event
  include Mongoid::Document

  field :subject, type: String
  field :category, type: String
  field :city, type: String
  field :place, type: String

  field :address, type: String
  field :url, type: String
  field :image_url, type: String
  field :details, type: String

  embeds_many :plans

  index( [
      [:subject, Mongo::ASCENDING ],
      [:category, Mongo::ASCENDING ],
      [:city, Mongo::ASCENDING ],
      [:place, Mongo::ASCENDING ]
    ],
    :unique=>true )


  SEARCHABLE_FIELDS = [:subject, :category, :city, :place, :address, :details]

  include Sunspot::Mongoid
  searchable do
    text *Event::SEARCHABLE_FIELDS, :stored=>true
    # date :date
    # time :time
    date :date do
      plans.first.date
    end
    time :time do
      plans.first.time
    end
  end
end

