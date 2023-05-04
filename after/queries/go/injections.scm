; extends
(const_spec
  name: (identifier) @_name (#match? @_name "[Q|q]uery")
  value: (expression_list
    (raw_string_literal) @sql)
    (#offset! @sql 0 1 0 -1))
