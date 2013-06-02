class CreateCustomFields < ActiveRecord::Migration
  def change
    change_table :custom_fields do |t|
      t.integer :first_date_id
      t.integer :second_date_id
      t.integer :operation_id
      t.string :true_message
      t.string :false_message
    end
  end
end
