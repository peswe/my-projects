class Order < ActiveRecord::Base
  def production
    Production.find(self.production_id)
  end

  def price
    return 100
  end
  #a test comment
end
