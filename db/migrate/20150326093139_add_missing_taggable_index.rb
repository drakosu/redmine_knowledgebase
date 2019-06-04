class AddMissingTaggableIndex < ActiveRecord::Migration
  def self.up
    unless index_exists?(:taggings, :taggable_id)
      add_index :taggings, [:taggable_id, :taggable_type, :context]
      @index_miscs_on_taggings_added_by_kb = true
    end
  end
  def self.down
    @index_miscs_on_taggings_added_by_kb ||= false

    if @index_miscs_on_taggings_added_by_kb and index_exists?(:taggings, :taggable_id)
      remove_index :taggings, [:taggable_id, :taggable_type, :context]
      @index_miscs_on_taggings_added_by_kb = false
    end
  end
end
