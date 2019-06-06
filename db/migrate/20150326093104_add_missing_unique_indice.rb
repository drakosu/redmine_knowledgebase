class AddMissingUniqueIndice < ActiveRecord::Migration
  def self.up

    create_table :kb_20150326093104_dummy  # dummy table for recording migration actions.

    unless index_exists?(:tags, :name)
      add_index :tags, :name, unique: true
      add_column :kb_20150326093104_dummy, :index_name_added_by_kb, :integer
    end
    if index_exists?(:taggings, :tag_id)
      remove_index :taggings, :tag_id
      add_column :kb_20150326093104_dummy, :index_tagid_removed_by_kb, :integer
    end
    if index_exists?(:taggings, [:taggable_id, :taggable_type, :context])
      remove_index :taggings, [:taggable_id, :taggable_type, :context]
      add_column :kb_20150326093104_dummy, :index_miscs_removed_by_kb, :integer
    end
    unless index_name_exists?(:taggings, 'taggings_idx', default = nil)
      add_index :taggings,
        [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
        unique: true, name: 'taggings_idx'
      add_column :kb_20150326093104_dummy, :index_taggings_idx_added_by_kb, :integer
    end

  end

  def self.down

    if column_exists?(:kb_20150326093104_dummy, :index_name_added_by_kb) and index_exists?(:tags, :name)
      remove_index :tags, :name
    end
    if column_exists?(:kb_20150326093104_dummy, :index_taggings_idx_added_by_kb) and index_name_exists?(:taggings, 'taggings_idx', default = nil)
      remove_index :taggings, name: 'taggings_idx'
    end
    if column_exists?(:kb_20150326093104_dummy, :index_tagid_removed_by_kb) and !index_exists?(:taggings, :tag_id)
      add_index :taggings, :tag_id
    end
    if column_exists?(:kb_20150326093104_dummy, :index_miscs_removed_by_kb) and !index_exists?(:taggings, [:taggable_id, :taggable_type, :context])
      add_index :taggings, [:taggable_id, :taggable_type, :context]
    end

    drop_table :kb_20150326093104_dummy

  end
end
