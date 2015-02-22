class Gif < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :url
  paginates_per 4

  scope :unpublished, ->{ where(published_at: nil) }
  scope :published, ->{ where("published_at is NOT ?", nil).where('hidden is ? or hidden = ?', nil, false) }
  scope :sfw, ->{ where('nsfw is ? or nsfw = ?', nil, false) }
  scope :nsfw, ->{ where(nsfw: true) }
  scope :visible, ->{ published.sfw }
  scope :random, ->{ order('random()') }
  scope :ordered, ->{ order('published_at DESC').order('created_at DESC').order('id DESC') }
  scope :in_trash, ->{ where(hidden: true) }
  scope :not_shared, ->{ where.not(shared: true) }

  attr_accessor :social_share

  def self.search(query)
    Gif.visible.fuzzy_search(title: query)
  end

  def prev
    Gif.visible.order(:id).where("id > ?", id).first || Gif.visible.order(:id).first
  end

  def next
    Gif.visible.order(:id).where("id < ?", id).last || Gif.visible.order(:id).last
  end

  def to_param
    return super unless persisted?
    "#{id}-#{title.to_s.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  def self.pick_random
    visible.random.first
  end

  def self.by_params(params)
    Gif.visible.ordered.page(params[:page])
  end

  def publish
    self.published_at = Time.now.utc
  end

  def publish!
    publish
    save!
  end

  def videoable?
    url.to_s.match(/imgur\.com\/\w+\.gif$/)
  end

  def url_for_format(format, query_params = '')
    raise "Gif not videoable" unless videoable?
    url.gsub('.gif', format) + query_params
  end

  def directified_url
    if url.to_s.match(/imgur\.com\/(gallery\/)?\w+$/)
      url.gsub(/gallery\//, '').gsub(/imgur/, 'i.imgur') + '.gif'
    else
      url
    end
  end
end
