class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :login
      t.string :type, limit: 1, default: 'N'

      t.timestamps
    end
    add_index :users, :login, unique: true
  end
end
