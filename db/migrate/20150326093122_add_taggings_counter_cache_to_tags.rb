class AddTaggingsCounterCacheToTags < ActiveRecord::Migration
  def self.up

    create_table :kb_20150326093122_dummy  # dummy table for recording migration actions.

    unless column_exists?(:tags, :taggings_count)
      add_column :tags, :taggings_count, :integer, default: 0
      add_column :kb_20150326093122_dummy, :index_count_added_by_kb, :integer
    end
    ActsAsTaggableOn::Tag.reset_column_information
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    end
  end

  def self.down
    
    if column_exists?(:kb_20150326093122_dummy, :index_count_added_by_kb) and column_exists?(:tags, :taggings_count)
      remove_column :tags, :taggings_count
    end

    drop_table :kb_20150326093122_dummy

  end
end
