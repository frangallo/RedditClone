# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  sub_id     :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  validates :author, :title, presence: true
  validate :has_at_least_one_sub

  belongs_to(
    :author,
    class_name: :User,
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :post_subs,
    class_name: :PostSub,
    foreign_key: :post_id,
    primary_key: :id,
    inverse_of: :post
  )

  has_many :subs, through: :post_subs, source: :sub

  private

  def has_at_least_one_sub
    errors[:subs] << "Post must belong to at least one sub" if subs.empty?
  end
end
