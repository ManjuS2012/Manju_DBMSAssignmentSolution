 /* CREATE SCHEMA `travelonthego` ; */
 
create table PASSENGER
 (
	  Passenger_name varchar(20), 
	  Category               varchar(20),
	  Gender                 varchar(20),
	  Boarding_City      varchar(20),
	  Destination_City   varchar(20),
	  Distance                int,
	  Bus_Type             varchar(20)
);
       
create table PRICE
(
	Bus_Type   varchar(20),
	Distance    int,
	Price      int
);
       
insert into passenger values('Sejal','AC','F','Bengaluru','Chennai',350,'Sleeper');
insert into passenger values('Anmol','Non-AC','M','Mumbai','Hyderabad',700,'Sitting');
insert into passenger values('Pallavi','AC','F','panaji','Bengaluru',600,'Sleeper');
insert into passenger values('Khusboo','AC','F','Chennai','Mumbai',1500,'Sleeper');
insert into passenger values('Udit','Non-AC','M','Trivandrum','panaji',1000,'Sleeper');
insert into passenger values('Ankur','AC','M','Nagpur','Hyderabad',500,'Sitting');
insert into passenger values('Hemant','Non-AC','M','panaji','Mumbai',700,'Sleeper');
insert into passenger values('Manish','Non-AC','M','Hyderabad','Bengaluru',500,'Sitting');
insert into passenger values('Piyush','AC','M','Pune','Nagpur',700,'Sitting');
    
select * from passenger;

INSERT INTO price values ('Sleeper', 350,770);
INSERT INTO price values ('Sleeper', 500, 1100);
INSERT INTO price values ('Sleeper', 600, 1320);
INSERT INTO price values ('Sleeper', 700, 1540);
INSERT INTO price values ('Sleeper', 1000, 2200);
INSERT INTO price values ('Sleeper', 1200 ,2640);
INSERT INTO price values ('Sleeper', 1500, 2700);
INSERT INTO price values ('Sitting', 500, 620);
INSERT INTO price values ('Sitting', 600, 744);
INSERT INTO price values ('Sitting', 700 ,868);
INSERT INTO price values ('Sitting', 1000 ,1240);
INSERT INTO price values ('Sitting', 1200, 1488);
INSERT INTO price values ('Sitting', 1500, 1860);

select * from price;

/* 3) How many females and how many male passengers travelled for a minimum distance of 600 KM s?*/

select Gender, COUNT(Gender) as numberOfPassenger
from passenger 
where Distance >= 600
GROUP BY Gender; 

/*4) Find the minimum ticket price for Sleeper Bus. */

SELECT * FROM price where bus_type = 'sleeper' 
	having min(price);

/*5) Select passenger names whose names start with character 'S' */

select passenger_name
from passenger 
where passenger_name like 'S%' ; 

/*6) Calculate price charged for each passenger displaying Passenger name, Boarding City, 
Destination City, Bus_Type, Price in the output */

select passenger.Passenger_Name, passenger.Boarding_City, 
passenger.Destination_City, passenger.Bus_Type, price.Price
from passenger , price
where price.Distance=passenger.Distance and passenger.bus_type = price.bus_type;

/*7) What are the passenger name/s and his/her ticket price who travelled in the Sitting bus 
for a distance of 1000 KM s */

select passenger.Passenger_Name, price.Price
from passenger , price
where passenger.Bus_Type ='Sitting' and passenger.Distance = 1000 and price.bus_type='sitting' and price.Distance=1000;

-- Since there is no result for 1000 Kms to ensure the output for 500 KMs test.
select passenger.Passenger_Name, price.Price
from passenger , price
where passenger.Bus_Type ='Sitting' and passenger.Distance = 500 and price.bus_type='sitting' and price.Distance=500;

/*8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to 
Panaji?*/

select price.Bus_Type,price.Distance,price.Price
from price 
where price.distance in (
		select distance from passenger 
where (Boarding_City = 'Bengaluru' and Destination_City = 'Panaji') or (Boarding_City = 'Panaji' and Destination_City = 'Bengaluru') and Passenger_name = 'Pallavi')
having price.Bus_Type='Sleeper' or price.Bus_Type='Sitting' ; 

/*9) List the distances from the "Passenger" table which are unique (non-repeated 
distances) in descending order.*/

-- the below will show all the distance once
SELECT DISTINCT distance FROM passenger ORDER BY Distance desc;

-- the below will remove the duplicated distance; which are being only once that distance alone will be displayed.
--  ex., 500 & 700 has duplication so that will not be displayed.
select Distance from passenger 
where passenger.Distance not in (
	SELECT Distance
	FROM passenger  
	GROUP BY Distance  
	HAVING COUNT(Distance) > 1
    ) order by Distance DESC;

/*10) Display the passenger name and percentage of distance travelled by that passenger 
from the total distance travelled by all passengers without using user variables */

SELECT Passenger_name, Distance * 100.0/ (SELECT SUM(Distance) FROM passenger) 
FROM passenger ;

/*11) Display the distance, price in three categories in table Price
a) Expensive if the cost is more than 1000
b) Average Cost if the cost is less than 1000 and greater than 500
c) Cheap otherwise*/

DELIMITER &&
	CREATE PROCEDURE PROC()
		BEGIN 
			SELECT price.distance,price.price,
            case
				when price.price > 1000 then 'Expensive'
                when price.price < 1000 and price.price > 500 then 'Average Cost'
                ELSE 'Cheap'
			end as Output from price ;
	END &&
DELIMITER ;

call PROC(); 


