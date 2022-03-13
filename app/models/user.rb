class User < ApplicationRecord
  # before_destroy:check_all_events_finishedを記述することで、削除時にcheck_all_events_finishedメソッドを呼び出せます
  before_destroy :check_all_events_finished

  # 関連の名前は、通常はモデル名である「events」になります。しかし今回は「関連元のユーザが作成したイベント」の関連であることがわかりやすくなるように、「created_events」という名前で設定しておきます。モデル名以外の名前を関連名に採用したので、class_nameオプションでモデルクラス名を指定しています。また、外部キーもデフォルトで使われるuser_idではないのでforeign_keyオプションで外部キーの名前を指定しています。
  has_many :created_events, class_name: "Event", foreign_key: "owner_id", dependent: :nullify

  # has_manyにdependent::nullifyオプションを追加することで、削除した時に、関連するレコードの外部キーをnullにできます
  has_many :tickets, dependent: :nullify
  has_many :participating_events, through: :tickets, source: :event

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    # 引数で渡したproviderとuidを持つレコードが存在していれば、そのオブジェクトを返す・存在しなければprovider、uid、name、image_urlを設定してレコードを作成し、そのオブジェクトを返す
    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = nickname
      user.image_url = image_url
    end
  end

# 作成したイベントの終了日時と、参加表明したイベントの終了日時を調べ、終わっていないものがあればerrorsオブジェクトにエラーメッセージを追加しています。最後にエラーの有無を調べ、エラーが存在していた場合はthrow(:abort)として削除処理を中断しています。
  def check_all_events_finished
    now = Time.zone.now
    if created_events.where(":now < end_at", now: now).exists?
      errors[:base] << "公開中の未終了イベントが存在します。"
    end

    if participating_events.where(":now < end_at", now: now).exists?
      errors[:base] << "未終了の参加イベントが存在します。"
    end

    throw(:abort) unless errors.empty?
  end
end
