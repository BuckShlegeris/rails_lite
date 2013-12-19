class Human < SQLObjectBase
  set_table_name("humans")
  my_attr_accessible(:id, :fname, :lname, :house_id)

  has_many :cats, :foreign_key => :owner_id
  belongs_to :house

  def name
    "#{fname} #{lname}"
  end
end