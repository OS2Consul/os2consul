class AddApprovedToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :approved, :bool
  end
end
