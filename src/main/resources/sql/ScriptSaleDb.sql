/* 
 * login accounts 
 */
drop table if exists accounts cascade;

CREATE TABLE accounts (
	username varchar(20) primary key,
	"password" varchar(60),
	rolename varchar(20),
	enabled bool default true
);

insert into accounts(username, "password", rolename)
values ('tea', md5('tea'), 'ROLE_ADMIN')


/* 
 * configuration for system 
 */
drop table if exists config cascade;

create table config (
	id serial primary key,
	key varchar(50) not null,
	value varchar(100) not null,
	del boolean default false
);

insert into config(key, value)
	values ('programmer', 'TheAnh');

select *
from config;



/*
 * provider information list
 */
drop table if exists provider cascade;

create table provider (
	id serial primary key,
	name varchar(100) unique,
	del boolean default false
);

insert into provider (name)
	values ('Trung Nguyên');

insert into provider (name)
	values ('Wonderfarm');

insert into provider (name)
	values ('Number One');

select * from provider;


/*
 * product information list
 */
drop table if exists product cascade;

create table product (
	 id serial primary key,
	 name varchar(100) not null,
	 unit varchar(20),
	 provider_id int references provider(id),
	 weight decimal default 0,
	 del boolean default false
);

select * from product;


drop table if exists price cascade;

create table price (
	id serial primary key,
	product_id int references product(id) not null,
	price decimal not null default 0,
	cate varchar(30),
	enabled boolean default true,
	del boolean default false
);

select e.id, e.product_id, p.name, e.cate, e.price
from price e
	join product p on (p.id=e.product_id)
where e.del=false;


/*
 * product number in stock
 */
drop table if exists inventory cascade;

create table inventory (
	id serial primary key,
	product_id int references product(id) not null,
	instock decimal not null default 0,
	trackmonth char(2),
	trackyear char(4),
	del boolean default false
);

select * from inventory;


/*
 * customer information
 */
drop table if exists customer cascade;

create table customer (
	id serial primary key,
	name varchar(100) unique not null,
	address varchar(100),
	district varchar(20),
	province varchar(20),
	contact varchar(30),
	phone varchar(15),
	del boolean default false
);

select * from customer;


/*
 * invoice (with customer and total information)
 */
drop table if exists invoice cascade;

create table invoice (
	id serial primary key,
	customer_id int references customer(id),
	saledate timestamp without time zone,
	weight decimal default 0,
	total decimal default 0,
	delivered smallint default 0,
	paid smallint default 0,
	del boolean default false
);

select * from invoice;




/*
 * invoice detail (with product and quantity)
 */
drop table if exists invoicedetail;

create table invoicedetail (
	id serial primary key,
	invoice_id int references invoice(id),
	product_id int references product(id),
	price_id int references price(id),
	product_price decimal,
	quantity decimal,
	amount decimal,
	del boolean default false
);

CREATE INDEX idx_invoicedetail_invoiceid
ON invoicedetail(invoice_id);

select * from invoicedetail;



-- update invoice weight
update invoice set weight=0;
update invoice v
set weight=w.weight
from
	(select i.invoice_id, sum(i.quantity * p.weight) as weight
	from invoicedetail i 
		join product p on (i.product_id=p.id)
	where i.del=false
	group by i.invoice_id) w
where v.id=w.invoice_id and v.del=false;

-- update invoice total
update invoice set total=0;
update invoice v
set total=t.total
from
	(select i.invoice_id, sum(i.quantity * p.price) as total
	from invoicedetail i 
		join price p on (i.price_id=p.id)
	where i.del=false
	group by i.invoice_id) t
where v.id=t.invoice_id and v.del=false;


