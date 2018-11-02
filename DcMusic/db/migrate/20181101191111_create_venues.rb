class CreateVenues < ActiveRecord::Migration[5.0]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :website
      t.string :headline_identifier
      t.string :support_identifier

      t.timestamps
    end
  end
end
