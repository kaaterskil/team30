class CreateWeighIn < ActiveRecord::Migration
  def change
    create_table :weigh_ins do |t|
      t.integer :user_id, null:false
      t.date :entry_date, null:false
      t.integer :measured_weight, null:false
      t.integer :total_calories

      t.timestamps
    end

    add_index :weigh_ins, :user_id
    add_index :weigh_ins, :entry_date
  end
end
