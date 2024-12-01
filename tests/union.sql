select * from catalog_hive.sales.customers
union
select * from catalog_iceberg.sales.customers;

select * from catalog_hive.product.employees where department = 'Engineering';

select e.id, e.name, abc.a, abc.b from  catalog_hive.product.employees e join catalog_iceberg.mydb.abc abc on e.id = abc.a;