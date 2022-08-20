class AddStatusToAnimal < ActiveRecord::Migration[6.1]
  def change
    add_column :animals, :status, :integer, default: 0
  end
end
