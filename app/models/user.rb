class User < ApplicationRecord
  # 関連の名前は、通常はモデル名である「events」になります。しかし今回は「関連元のユーザが作成したイベント」の関連であることがわかりやすくなるように、「created_events」という名前で設定しておきます。モデル名以外の名前を関連名に採用したので、class_nameオプションでモデルクラス名を指定しています。また、外部キーもデフォルトで使われるuser_idではないのでforeign_keyオプションで外部キーの名前を指定しています。
  has_many :created_events, class_name: "Event", foreign_key: "owner_id"

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
end
