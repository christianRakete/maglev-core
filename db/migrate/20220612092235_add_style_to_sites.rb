class AddStyleToSites < ActiveRecord::Migration[6.1]
  def change
    change_table :maglev_sites do |t|
      t.jsonb :style, default: []
    end
  end
end
