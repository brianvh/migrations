class MobileEmailClientChoice < Choice
  
  def self.to_options_array
    all.collect { |choice| choice.value } << "Don't know"
  end
  
end