class CreateAnimals < ActiveRecord::Migration[6.1]
  def change
    create_table :animals do |t|
      t.string :name
      t.float :age
      t.string :specie
      t.string :gender
      t.string :size

      t.timestamps
    end
  end
end
