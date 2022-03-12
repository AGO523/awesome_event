class Ticket < ApplicationRecord
  # user_idはnilになることがあるので、belongs_toにoptional:trueを追加して関連先がなくてもバリデーションエラーにならないようにしておきます
  belongs_to :user, optional: true
  belongs_to :event

  # バリデーションは「commentは30文字以内、空文字やnilを許可」とします
  validates :comment, length: { maximum: 30 }, allow_blank: true
end
