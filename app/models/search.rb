class Search
  SECTIONS = %w(everywhere questions answers comments users)
  def self.find(query, section)
    raise Exceptions::NonExistSection unless Search::SECTIONS.include?(section)
    query = Riddle::Query.escape(query)
    return ThinkingSphinx.search(query) if section == 'everywhere'
    section.classify.constantize.search(query)
  end
end
