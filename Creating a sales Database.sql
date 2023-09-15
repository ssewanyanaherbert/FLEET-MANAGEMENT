create database MAHE;
show databases;
use Mahe;
drop table Sale_Bill;
create table Sale_Bill(bill_no int not null primary key, Bill_date date, Gst int);
select * from Sale_Bill;

drop table Item;
create table Item(item_code int, item_name varchar(25), purchase_price int, Selling_price int, bill_no int,
primary key (item_code),
foreign key (bill_no) references Sale_Bill(bill_no) on delete set null
);
select * from Item;

drop table Customer;
create table Customer(Customer_name varchar(25), Mobile_number int, Adress varchar(30), bill_no int, item_code int,
primary key (Mobile_number),
foreign key (bill_no) references Sale_Bill (bill_no),
foreign key (item_code) references item (item_code)

);
select * from Customer;

drop table Quantity;
create table Quantity(item_code int, Category varchar(15) , Quantity_stocked int, Quantity_sold int,
 Quantity_in_hand int,
 primary key (item_code,category)
 );
 show full columns from Quantity;
  
  alter table quantity
  add column reorder_level int;
  
 #Quering Transactions (a check has to be made to see if the items are available (quantity-in-hand > items required) in the ITEM table)

 Start transaction;
 select i.item_code, Q.Category, Q.Quantity_sold, Q.Quantity_in_hand
 from Item as i, Quantity as Q
 where (Quantity_sold > quantity_in_hand);
 commit;
 
 #Once the bill details are inserted into the BILL table, the quantity in hand in ITEM table should be updated.
 start transaction;
 select * from sale_bill;
 select * from item;
 select * from customer;
 select * from quantity;
update quantity
set quantity_in_hand = (Quantity_stocked - Quantity_sold) where item_code = 123 ;
commit;
 
# PURCHASE_REQUEST_trigger
drop table Purchase_request;
create table Purchase_request(purcha_request_number int primary key,
 quantity_to_order int, item_code int, item_name varchar(25),
 foreign key (item_code) references Item(item_code)
 );
 
Delimiter //
create trigger Purc_Request
after insert on item
FOR EACH ROW
BEGIN
if quantity_in_hand = reorder_level then 
insert into Purchase_request
values (purcha_request_number, quantity_to_order,item_code, item_name);
 END if;
 END //
 Delimiter ;

