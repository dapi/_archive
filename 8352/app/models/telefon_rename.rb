class TelefonRename < ActiveRecord::Base
  
  validates_presence_of :oldphone, :newphone, :rename_date
  validates_uniqueness_of  :oldphone, :newphone
  validates_format_of   :oldphone, :with => /^7\d\d\d+$/
  validates_format_of   :newphone, :with => /^7\d\d\d+$/


  def self.rename_number(phone)
    
    renames=TelefonRename.
      find_by_sql ["select  newphone || substr(?,length(oldphone)+1,12) as newnumber from telefon_renames where substr(?,1,length(oldphone))=oldphone",
                  phone,phone]
    
    return renames.size>0 ? renames[0].newnumber : phone


#    numbers = self.find_by_sql(["select newphone || substr(?,length(oldphone)+1,12) as newnumber from telefon_renames where substr(?,1,length(oldphone))=oldphone", phone_number, phone_number])
#    numbers.first.newnumber unless numbers.empty?
  end

end
