class AddGenderHeightAndBirthdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :height, :integer
    add_column :users, :birth_date, :date
  end
end
