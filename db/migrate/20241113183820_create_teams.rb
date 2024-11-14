class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description
      t.references :owner, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
  end
end
