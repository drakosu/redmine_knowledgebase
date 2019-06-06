class AddMissingTaggableIndex < ActiveRecord::Migration
  def self.up

    create_table :kb_20150326093139_dummy  # dummy table for recording migration actions.

    unless index_exists?(:taggings, :taggable_id)
      add_index :taggings, [:taggable_id, :taggable_type, :context]
      add_column :kb_20150326093139_dummy, :index_miscs_added_by_kb, :integer
    end

  end

  def self.down

    if column_exists?(:kb_20150326093139_dummy, :index_miscs_added_by_kb) and index_exists?(:taggings, :taggable_id)
      remove_index :taggings, [:taggable_id, :taggable_type, :context]
    end

    drop_table :kb_20150326093139_dummy

  end
end
