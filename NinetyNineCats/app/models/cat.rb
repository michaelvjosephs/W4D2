# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Cat < ActiveRecord::Base
  COLORS = %w(White Black Brown Orange)

  validates :birth_date, presence: true
  validates :name, presence: true
  validates :sex, inclusion: { in: %w(M F), message: "must be M or F" }, presence: true
  validates :color, inclusion: { in: COLORS, message: "not valid" }, presence: true

  has_many :cat_rental_requests,
    dependent: :destroy,
    class_name: 'CatRentalRequest',
    primary_key: :id,
    foreign_key: :cat_id

  def age
    Date.today.year - birth_date.year
  end

end
