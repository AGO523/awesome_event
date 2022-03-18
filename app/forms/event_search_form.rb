class EventSearchForm
  # ActiveModel::Modelをインクルードすることで、モデルとして必要な振る舞いを追加しています。このモデルの属性はkeyword、page、start_atです。
  include ActiveModel::Model
  include ActiveModel::Attributes
  # keywordとpageは、ActiveModel::Attributesモジュールのattributeメソッドを利用しセッターとゲッターを定義しています
  attribute :keyword, :string
  attribute :page, :integer

  def search
    # Event.searchがsearchkickで検索する時のメソッドになります
    Event.search(
      keyword_for_search,
      where:{ start_at: { gt: start_at } },
      # searchkickはデフォルトでkaminariを利用したページングに対応しているので、ページングに関してはpageとper_pageオプションをsearchメソッドに渡すだけです。
      page: page,
      per_page: 10
    )
  end

  # start_atはkeywordやpageと違い、セッターとゲッターを独自に定義するようにしています。これはフォームからの入力がない時に現在時刻をデフォルト値にしたり、フォームから文字列で入力された日時をActiveSupport::TimeWithZoneオブジェクトに変換するなど、独自の処理が必要なためです。
  def start_at
    @start_at || Time.current
  end

  def start_at=(new_start_at)
    @start_at = new_start_at.in_time_zone
  end

  private

  # "*"で検索するとすべての検索結果が表示されるので、何も入力がない時は"*"で検索するようにしています
  def keyword_for_search
    keyword.presence || "*"
  end
end
