# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint(8)        not null, primary key
#  long_url  :string           not null
#  short_url :string           not null
#  user_id   :integer          not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  
  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: 'User'
  
  has_many :visits,
  primary_key: :id,
  foreign_key: :shortened_url_id,
  class_name: 'Visit'
  
  has_many :visitors,
  Proc.new { distinct },
  through: :visits,
  source: :user
  
  def self.random_code(user, long_url)
    user_id = user.id
    short_url = SecureRandom.urlsafe_base64
    ShortenedUrl.create!(user_id: user_id, long_url: long_url, short_url: short_url)
  end
  
  def num_clicks
    visits.count
  end
  
  def num_uniques
    visits.select('user_id').distinct.count
  end
  
  def num_recent_uniques
    visits
      .select('user_id')
      .where('created_at > ?', 10.minutes.ago)
      .distinct
      .count
  end
end
