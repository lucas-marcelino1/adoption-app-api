class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :details
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
