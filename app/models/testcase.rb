class Testcase < ActiveRecord::Base
  belongs_to :project
  attr_accessible :data, :name
end
