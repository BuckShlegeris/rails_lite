class House < SQLObjectBase
  set_table_name("houses")
  my_attr_accessible(:id, :address, :house_id)
end