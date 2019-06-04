class AddMissingUniqueIndice < ActiveRecord::Migration
  def self.up
    unless index_exists?(:tags, :name)
      add_index :tags, :name, unique: true
      @index_tags_on_name_added_by_kb = true
    end
    if index_exists?(:taggings, :tag_id)
      remove_index :taggings, :tag_id
      @index_tagid_on_taggings_removed_by_kb = true
    end
    if index_exists?(:taggings, [:taggable_id, :taggable_type, :context])
      remove_index :taggings, [:taggable_id, :taggable_type, :context]
      @index_miscs_on_taggings_removed_by_kb = true
    end
    unless index_name_exists?(:taggings, 'taggings_idx', default = nil)
      add_index :taggings,
        [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
        unique: true, name: 'taggings_idx'
      @index_taggings_idx_on_taggings_added_by_kb = true
    end
  end

  def self.down
    @index_tags_on_name_added_by_kb ||= false
    @index_tagid_on_taggings_removed_by_kb ||= false
    @index_miscs_on_taggings_removed_by_kb ||= false
    @index_taggings_idx_on_taggings_added_by_kb ||= false

    if @index_tags_on_name_added_by_kb and index_exists?(:tags, :name)
      remove_index :tags, :name
      @index_tags_on_name_added_by_kb = false
    end
    if @index_taggings_idx_on_taggings_added_by_kb and index_name_exists?(:taggings, 'taggings_idx', default = nil)
      remove_index :taggings, name: 'taggings_idx'
      @index_taggings_idx_on_taggings_added_by_kb = false
    end
    if @index_tagid_on_taggings_removed_by_kb and !index_exists?(:taggings, :tag_id)
      add_index :taggings, :tag_id
      @index_tagid_on_taggings_removed_by_kb = false
    end
    if @index_miscs_on_taggings_removed_by_kb and !index_exists?(:taggings, [:taggable_id, :taggable_type, :context])
      add_index :taggings, [:taggable_id, :taggable_type, :context]
      @index_miscs_on_taggings_removed_by_kb = false
    end
  end
end
