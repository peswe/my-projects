class Order < ActiveRecord::Base
  def production
    Production.find(self.production_id)
  end
end
