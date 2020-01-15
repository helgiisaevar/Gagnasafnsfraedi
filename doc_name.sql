CREATE TABLE Coffees( 
name VARCHAR(20) PRIMARY KEY, 
manufacturer VARCHAR(20) 
); 

CREATE TABLE Coffeehouses( 
name VARCHAR(10) PRIMARY KEY, 
address VARCHAR(10) , 
license CHAR(10) UNIQUE 
); 

CREATE TABLE Drinkers( 
name VARCHAR(10) PRIMARY KEY, 
address VARCHAR(10), 
phone CHAR(10)
); 
CREATE TABLE Likes( 
drinker VARCHAR(10) REFERENCES Drinkers(name) PRIMARY KEY, 
coffee VARCHAR(10) REFERENCES Coffees(name) 
); 

CREATE TABLE Frequents( 
drinker VARCHAR(20) REFERENCES Drinkers(name) PRIMARY KEY, 
coffeehouse VARCHAR(20) REFERENCES Coffeehouses(name) 
); 

CREATE TABLE Sells( 
coffeehouse VARCHAR(20) 
REFERENCES Coffeehouses(name), 
coffee VARCHAR(20) REFERENCES Coffees(name),
price INT
); 

INSERT INTO Coffees(name,manufacturer) 
VALUES 
(‘Argentinian coffee’, ‘Argentina’),
 (‘Mexican coffee’, ‘Mexico’)

INSERT INTO Coffeehouses(name, address, licence)
	VALUES 
(‘Kaffihus Helga’, ‘smararimi 14’,’1123’),
(‘Kaffihus Hannesar’,’mosarimi 18’,’1124’)

INSERT INTO Drinkers(name, address, phone)
	VALUES 
(‘Helgi’,’ofanleiti 1’,’833-2323’),
(‘Baldur’,soleyrarhus 2’,’843-3454’)
INSERT INTO Likes(drinker, coffee)
	VALUES 
(‘Helgi’,’Argentinian coffee’),
(‘Baldur’,’Mexican coffee’)

INSERT INTO Frequents(drinker, coffeehouse)
	VALUES 
(‘Helgi’,’Kaffihus Hannesar’),
(‘Baldur’,’Kaffihus Helga’)

INSERT INTO Sells(coffeehouse, coffee, price)
VALUES 
(‘Kaffihus Hannesar’,’Argentinian coffee’, 500),
(‘Kaffihus Helga’,’Mexican coffee’,600)

SELECT Likes, Name
WHERE coffee = ‘Argentinian coffee’

DELETE 
FROM Sells;
DELETE 
FROM Frequence;
DELETE 
FROM Likes;
DELETE 
FROM Drinks;
DELETE 
FROM Coffeehouses;
DELETE 
FROM Coffee;

DROP TABLE Sells;
DROP TABLE Frequence;
DROP TABLE Likes;
DROP TABLE Drinks;
DROP TABLE Coffeehouses;
DROP TABLE Coffee;
