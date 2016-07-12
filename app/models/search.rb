class Search
  SECTIONS = %w(everywhere questions answers comments users)
  def self.find(query, section)
    return ThinkingSphinx.search(query) if section == 'everywhere'
    section.classify.constantize.search(query)
  end
end
