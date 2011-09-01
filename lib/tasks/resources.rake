namespace :resources do
  
  desc 'Import csv file of Oracle Calendar resources'
  task :import => :environment do
    result = ResourceImporter.import("#{Rails.root}/tmp/resources_to_import.csv")
    p result
  end
  
end
