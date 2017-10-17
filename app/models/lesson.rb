class Lesson < ApplicationRecord

  belongs_to :path
  validates :name, presence: true, length: { in: 4..55 }
  validates :content, presence: true, length: { in: 5..50000 }
  INVALID_CONTENT_REGEX = /(<script+|<img+|<!--+)/i
  validate :valid_content

  def valid_content
    errors.add(:content, "is not valid") if INVALID_CONTENT_REGEX.match(content)
  end

end
