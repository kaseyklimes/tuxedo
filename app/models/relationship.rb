require 'recipe.rb'
require 'component.rb'
require 'list.rb'
require 'custom_markdown.rb'

class Relationship < ActiveRecord::Base

  belongs_to :relatable, :polymorphic => true
  before_save :generate_key
  after_create :update_cache
  after_destroy :update_cache

  def child
    child_type.constantize.find_by_id(child_id)
  end

  def expand #tries to expand a relationship based on custom "field" type
    if field == "expandable_list_content"
      child_type.constantize.find_by_id(child_id).try(:parent_elements) || []
    else
      return nil
    end
  end

  def generate_key
    self.key = "#{relatable.class.to_s}_#{relatable.id}_#{child.class.to_s}_#{child.id}_#{field}"
    return Relationship.find_by_key(key) if Relationship.exists?(:key => key)
  end

  def update_cache
    child.touch if child
  end

  def self.find_parents(child)
    relationships = where(child_type: child.class.to_s, child_id: child.id)
    relationships.map{|relationship| relationship.relatable}
  end

  def self.find_parents_by_type(child, type)
    relationships = where(child_type: child.class.to_s, child_id: child.id, relatable_type: type.to_s)
    relationships.map{|relationship| relationship.relatable}
  end

  def self.touch_all_parents_of(child_element)
    self.find_parents(child_element).map(&:touch)
  end
end
