class Search
  SECTIONS = %w(questions)
  def self.find(query, section)
    section.classify.constantize.search(query)
  end
end
