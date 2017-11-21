class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :loginname
      t.string :password_digest
      t.string :fullname
      t.string :image

      t.timestamps
    end
  end
end
