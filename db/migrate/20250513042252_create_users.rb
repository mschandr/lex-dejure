class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.references :organization, null: false, foreign_key: true
      t.boolean :confirmed
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    add_index :users, :email
  end
end
