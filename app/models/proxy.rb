class Proxy < ActiveRecord::Base
  belongs_to :project
  attr_accessible :bind_port, :forward_ip, :forward_port, :name, :protocol, :project_id
end
