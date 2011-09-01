require 'csv'

class ResourceImporter
  
  def self.import(csv_file)
    rsc_count = 0
    CSV.open(csv_file, 'r', ',') do |row|
      p_owner = User.lookup_by_name(row[1])
      
      rsc = Resource.create(:name => row[0],
                      :dept => row[3],
                      :oc_user => row[5],
                      :name_other => row[17],
                      :affiliation => row[18],
                      :dept_group => row[19],
                      :primary_owner_id => p_owner.nil? ? nil : p_owner.id,
                      :secondary_owner_name => row[2].blank? ? nil : row[2]
                      )
      rsc_count+=1
    end
    "#{rsc_count} resource(s) imported"
  end
  
end
