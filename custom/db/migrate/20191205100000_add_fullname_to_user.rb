# frozen_string_literal: true

class AddFullnameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fullname, :string
  end
end
