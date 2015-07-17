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
  validates :author, :sub, :title, presence: true

  belongs_to(
    :author,
    class_name: :User,
    foreign_key: :author_id,
    primary_key: :id
  )

  belongs_to(
    :sub,
    class_name: :Sub,
    foreign_key: :sub_id,
    primary_key: :id
  )
end
