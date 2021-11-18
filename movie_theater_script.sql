CREATE TABLE "customer" (
  "customer_id" serial PRIMARY KEY,
  "first_name" varchar(50),
  "last_name" varchar(50)
);

CREATE TABLE "ticket" (
  "ticket_id" serial PRIMARY KEY,
  "showtime" time,
  "price" float,
  "customer_id" int,
  "movie_id" int
);

CREATE TABLE "movie" (
  "movie_id" serial PRIMARY key,
  "title" varchar(50),
  "description" text,
  "runtime" time,
  "rating" varchar(5)
);

CREATE TABLE "concession_purchase" (
  "purchase_id" serial PRIMARY KEY,
  "price" float,
  "customer_id" int
);

CREATE TABLE "concession_items_in_purchase" (
  "item_id" int,
  "purchase_id" int
);

CREATE TABLE "concession_item" (
  "item_id" serial PRIMARY KEY,
  "price" float,
  "name" varchar(50)
);

ALTER TABLE "ticket" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "ticket" ADD FOREIGN KEY ("movie_id") REFERENCES "movie" ("movie_id");

ALTER TABLE "concession_purchase" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "concession_items_in_purchase" ADD FOREIGN KEY ("item_id") REFERENCES "concession_item" ("item_id");

ALTER TABLE "concession_items_in_purchase" ADD FOREIGN KEY ("purchase_id") REFERENCES "concession_purchase" ("purchase_id");



-- adding data to tables: 

-- movies:

insert into movie(title, description, runtime, rating)
values('Space Conflict', 'There is a big conflict... in space!!!', '2:12', 'PG');

insert into movie(title, description, runtime, rating)
values('Knight Warrior', 'Hes a knight, hes a warrior. But can he find love?', '1:43', 'R');

insert into movie(title, description, runtime, rating)
values('Old Man City', 'New York City is full of old men!', '2:04', 'PG-13');

insert into movie(title, description, runtime, rating)
values('Helicopter Not Up', 'A helicopter crew is stuck. Will they get their helicopter to be up again?', '3:01', 'R');

insert into movie(title, description, runtime, rating)
values('Divorced Dad', 'A serious drama about the struggles of being a divorced dad.', '4:32', 'NC-17');

insert into movie(title, description, runtime, rating)
values('Bugdom: The Movie', 'Based on the classic computer game Bugdom', '1:28', 'G');

-- customers:

insert into customer(first_name, last_name)
values('Shelby', 'McClure');

insert into customer(first_name, last_name)
values('Heinz', 'Schleiffenschlacht');

insert into customer(first_name, last_name)
values('Darius', 'Dodderfield');


insert into customer(first_name, last_name)
values('Hardy', 'Porter');


insert into customer(first_name, last_name)
values('Jordan', 'Ryan');

insert into customer(first_name, last_name)
values('Robert', 'Hand');


insert into customer(first_name, last_name)
values('Jello', 'Kennedy');

-- tickets:

insert into ticket(showtime, price, customer_id, movie_id)
values('9:00', 11.85, 1, 1);

insert into ticket(showtime, price, customer_id, movie_id)
values('9:00', 11.85, 1, 1);

insert into ticket(showtime, price, customer_id, movie_id)
values('3:00', 6.85, 2, 3);

insert into ticket(showtime, price, customer_id, movie_id)
values('7:10', 11.85, 3, 2);

insert into ticket(showtime, price, customer_id, movie_id)
values('7:10', 11.85, 3, 2);

insert into ticket(showtime, price, customer_id, movie_id)
values('10:00', 11.85, 4, 1);

insert into ticket(showtime, price, customer_id, movie_id)
values('7:30', 11.85, 5, 4);

insert into ticket(showtime, price, customer_id, movie_id)
values('3:15', 6.85, 6, 5);

insert into ticket(showtime, price, customer_id, movie_id)
values('3:15', 4.85, 6, 5);

insert into ticket(showtime, price, customer_id, movie_id)
values('3:15', 4.85, 6, 5);

insert into ticket(showtime, price, customer_id, movie_id)
values('8:30', 11.85, 7, 4);


-- snacks:

insert  into concession_item(price, name)
values(3.99, 'Popcorn');

insert  into concession_item(price, name)
values(1.99, 'M&Ms');

insert  into concession_item(price, name)
values(1.99, 'Skittles');

insert  into concession_item(price, name)
values(2.99, 'Soda');

-- purchases at concession stand:
insert into concession_purchase(customer_id)
values(1);

insert into concession_purchase(customer_id)
values(2);

insert into concession_purchase(customer_id)
values(4);

insert into concession_purchase(customer_id)
values(5);

insert into concession_purchase(customer_id)
values(6);

-- items in each purchase:

insert into concession_items_in_purchase(item_id, purchase_id)
values(1,1);

insert into concession_items_in_purchase(item_id, purchase_id)
values(4,1);


insert into concession_items_in_purchase(item_id, purchase_id)
values(4,1);

insert into concession_items_in_purchase(item_id, purchase_id)
values(3,2);

insert into concession_items_in_purchase(item_id, purchase_id)
values(4,3);

insert into concession_items_in_purchase(item_id, purchase_id)
values(2,4);


insert into concession_items_in_purchase(item_id, purchase_id)
values(1,4);


insert into concession_items_in_purchase(item_id, purchase_id)
values(1,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(2,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(2,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(3,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(3,5);


insert into concession_items_in_purchase(item_id, purchase_id)
values(4,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(4,5);

insert into concession_items_in_purchase(item_id, purchase_id)
values(4,5);


-- determining total price for purchase


create or replace procedure setPrice (
	_purchase_id int
)
language plpgsql
as $$
begin 
	update concession_purchase 
	set price = (select total_price
		from
		(
			select distinct purchase_id, sum(price) as total_price
			from concession_item
			join concession_items_in_purchase on concession_item.item_id = concession_items_in_purchase.item_id 
			group by purchase_id
		) as prices
		where purchase_id = _purchase_id )
	where purchase_id = _purchase_id;
	
	
	commit;
end;
$$

call setprice(1); 
select * from concession_purchase cp 
where purchase_id = 1;

call setprice(2);
call setprice(3);
call setprice(4);
call setprice(5); 
select * from concession_purchase cp ;
