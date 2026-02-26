class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :code, null: false
      t.integer :status, null: false,default: 0
      t.boolean :host_joined, nill: false, default: false
      
      t.timestamps
    end
    
    add_index :rooms, :code, unique: true
  end
end
