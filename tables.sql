create schema if not exists demo_dash;

set search_path to demo_dash;


create table if not exists customers(
    customer_key integer not null unique  --CustomerKey
    , full_name varchar(50) not null  --Name
    , date_of_birth date  --BirthDate
    , marital_status char(1)  --MaritalStatus
    , gender char(1)  --Gender
    , yearly_income decimal  --YearlyIncome
    , number_of_children integer  --NumberChildrenAtHome
    , occupation varchar(50)  --Occupation
    , house_owner_flag integer  --HouseOwnerFlag
    , number_cars_owned integer  --NumberCarsOwned
    , first_purchase_date date  --DateFirstPurchase
    , primary key(customer_key)
);


create table if not exists territory(
    territory_key serial  --Territory Key
    , region varchar(50)  --Region
    , country varchar(50)  --Country
    , geo_group varchar(50)  --Group
    , primary key(territory_key)
);


create table if not exists product_category(
    category_key serial  --ProductCategoryKey
    , category_name varchar(50)  --EnglishProductCategoryName
    , primary key(category_key)
);


create table if not exists product_subcategory(
    subcategory_key serial  --ProductSubcategoryKey
    , subcategory_name varchar(50)  --EnglishProductSubcategoryName
    , category_key integer  --ProductCategoryKey
    , primary key(subcategory_key)
    , foreign key(category_key) references product_category(category_key) on delete cascade
);


create table if not exists products(
    product_key integer not null unique  --ProductKey
    , subcategory_key integer  --ProductSubcategoryKey
    , product_name varchar(100)  --ProductName
    , standard_cost decimal  --StandardCost
    , color varchar(50)  --Color
    , safety_stock_level integer  --SafetyStockLevel
    , list_price decimal  --ListPrice
    , product_size varchar(20)  --Size
    , product_weight decimal  --Weight
    , days_to_manufacture integer  --DaysToManufacture
    , product_line varchar(20)  --ProductLine
    , dealer_price decimal  --DealerPrice
    , product_class varchar(20)  --Class
    , model_name varchar(100)  --ModelName
    , product_description text  --Description
    , start_date date  --StartDate
    , end_date date  --EndDate
    , product_status varchar(20)  --Status 
    , primary key(product_key)
    , foreign key(subcategory_key) references product_subcategory(subcategory_key) on delete cascade
);


create table if not exists sales(
    product_key integer  --ProductKey
    , order_date date  --OrderDate
    , order_datekey integer  --OrderDateKey
    , customer_key integer  --CustomerKey
    , territory_key integer  --SalesTerritoryKey
    , sales_order_number varchar(20)  --SalesOrderNumber
    , sales_order_line_number integer  --SalesOrderLineNumber
    , order_quantity integer  --OrderQuantity
    , unit_price decimal  --UnitPrice
    , total_product_cost decimal  --TotalProductCost
    , sales_amount decimal  --SalesAmount
    , tax_amount decimal  --TaxAmt
    , freight decimal  --Freight
    , foreign key(product_key) references products(product_key) on delete cascade
    , foreign key(customer_key) references customers(customer_key) on delete cascade
    , foreign key(territory_key) references territory(territory_key) on delete cascade
)