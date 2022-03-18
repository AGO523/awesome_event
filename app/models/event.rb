class Event < ApplicationRecord
  # 検索にKuromojiを利用する
  searchkick language: "japanese"

  # Eventモデルに画像を紐付けるための宣言を追加しますhas_one_attached:imageと宣言して、Eventモデルでimageという名前の属性が使えるようにします
  has_one_attached :image, dependent: false
  has_many :tickets, dependent: :destroy
  belongs_to :owner, class_name: "User"

  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :content, length: { maximum: 200 }, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_at_should_be_before_end_at
  validates :image, content_type: [:png, :jpg, :jpeg], size: { less_than_or_equal_to: 10.megabytes }, dimension: { width: { max: 2000 }, height: { max: 2000 }}

  attr_accessor :remove_image
  before_save :remove_image_if_user_accept

  def created_by?(user)
    return false unless user
    owner_id == user.id
  end

  def search_data
    {
      name: name,
      place: place,
      content: content,
      owner_name: owner&.name,
      start_at: start_at
    }
  end

  private

  def remove_image_if_user_accept
    self.image = nil if ActiveRecord::Type::Boolean.new.cast(remove_image)
  end

  def start_at_should_be_before_end_at
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, "は終了時間よりも前に設定してください")
    end
  end
end
