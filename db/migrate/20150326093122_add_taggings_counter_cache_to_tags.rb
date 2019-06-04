class AddTaggingsCounterCacheToTags < ActiveRecord::Migration
  def self.up
    unless column_exists?(:tags, :taggings_count)
      add_column :tags, :taggings_count, :integer, default: 0
      @column_count_on_tags_added_by_kb = true
    end
    ActsAsTaggableOn::Tag.reset_column_information
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    end
  end

  def self.down
    @column_count_on_tags_added_by_kb ||= false
    
    if @column_count_on_tags_added_by_kb and column_exists?(:tags, :taggings_count)
      remove_column :tags, :taggings_count
      @column_count_on_tags_added_by_kb = false
    end
  end
end
