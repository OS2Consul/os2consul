class AddBudgetMapSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :map_latitude, :decimal
    add_column :budgets, :map_longitude, :decimal
    add_column :budgets, :map_zoom, :integer
  end
end
