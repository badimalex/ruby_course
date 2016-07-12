class Search
  SECTIONS = %w(questions answers)
  def self.find(query, section)
    section.classify.constantize.search(query)
  end
end
