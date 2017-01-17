# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id , presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: %w(PENDING APPROVED DENIED), message: "must be Pending, Approved, or Denied" }
  validate :overlapping_approved_requests
  validate :start_date_before_end_date
  validate :start_date_after_today


  belongs_to :cat,
    class_name: 'Cat',
    primary_key: :id,
    foreign_key: :cat_id

  def hello
    puts "hello"
  end

  def approve!
    # debugger
    CatRentalRequest.transaction do
      overlapping_requests.each do |req|
        req.deny!
      end

      self.status = "APPROVED"
      self.save!
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  private

  def start_date_before_end_date
    unless start_date < end_date
      errors[:base] << "Start date must be before end date"
    end
  end

  def start_date_after_today
    unless start_date > Date.today
      errors[:start_date] << "must be in the future"
    end
  end

  def overlapping_requests
    all_requests = CatRentalRequest.where(cat_id: self.cat_id)
    where_str = "start_date > ? OR end_date < ?"
    all_requests.where.not(where_str, end_date, start_date)
  end

  def overlapping_approved_requests
    unless overlapping_requests.where(status: "APPROVED").empty?
      errors[:base] << "Request overlaps with another approved request."
    end
  end


end
