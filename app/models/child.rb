class Child < ApplicationRecord
  belongs_to :user
  has_many :recordings, dependent: :destroy

  validates :name, presence: true
  validates :birthday, presence: true
end
