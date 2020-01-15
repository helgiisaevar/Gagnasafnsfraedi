CREATE TABLE Coffees(
name VARCHAR(20) PRIMARY KEY,
manufacturer VARCHAR(20)
);
CREATE TABLE Coffeehouses(
name VARCHAR(30) PRIMARY key,
address VARCHAR(40) ,
license CHAR(10) UNIQUE
);
CREATE TABLE Drinkers(
name VARCHAR(40) PRIMARY key,
address VARCHAR(40),
phone CHAR(7)
);
CREATE TABLE Likes(
drinker VARCHAR(40) REFERENCES Drinkers(name) PRIMARY key ,
coffee VARCHAR(20) REFERENCES Coffees(name)
);
CREATE TABLE Frequents(
drinker VARCHAR(40) REFERENCES Drinkers(name) PRIMARY key ,
coffeehouse VARCHAR(30) REFERENCES Coffeehouses(name)
);
CREATE TABLE Sells(
coffeehouse VARCHAR(30) REFERENCES Coffeehouses(name),
coffee VARCHAR(20) REFERENCES Coffees(name),
price FLOAT
);
INSERT INTO coffees(name,manufacturer)
VALUES
('Blue Coffee','Coffee blue.co'),
('Red Coffee','Coffee red.co'),
('Green Coffee','Coffee green.co'),
('Orange Coffee','Coffee orange.co'),
('Hot Coffee','Coffee bad.co'),
('Bad Coffee','Coffee bad.co');
INSERT INTO coffeehouses(name,address,license)
VALUES
('Blue Coffeehouse','nesbali 24, 170','1234567891'),
('Red Coffeehouse','unnarbraut 23, 170','2248382737'),
('Green Coffeehouse','suÃ°urhÃºs 12, 230','3333333333'),
('Orange Coffeehouse','kringlubraut, 222','4444444444'),
('Hot Coffeehouse','faxafenn 11, 123','2233556688'),
('Bad Coffeehouse','Laugavegur 17,101','2222255555');
INSERT INTO drinkers(name,address,phone)
VALUES
('Tom Collins','nesbali 20, 170','1234567'),
('Johnnie Walker','unnarbraut 20, 170','2282737'),
('Green Coffehouse','suÃ°urhÃºs 10, 230','3333333'),
('William Grant','kringlubraut, 222','4444444'),
('Tom Chivas','faxafenn 100, 123','2256688'),
('John Bchman','Laugavegur 170, 101','2255555');
INSERT INTO likes(drinker,coffee)
VALUES
('Tom Collins','Blue Coffee'),
('Johnnie Walker','Red Coffee'),
('Green Coffehouse','Blue Coffee'),
('William Grant','Orange Coffee'),
('Tom Chivas','Blue Coffee'),
('John Bchman','Blue Coffee');
INSERT INTO frequents(drinker,coffeehouse)
VALUES
('Tom Collins','Blue Coffeehouse'),
('Johnnie Walker','Orange Coffeehouse'),
('Green Coffehouse','Blue Coffeehouse'),
('William Grant','Orange Coffeehouse'),
('Tom Chivas','Blue Coffeehouse'),
('John Bchman','Orange Coffeehouse');
INSERT INTO sells(coffeehouse,coffee,price)
VALUES
('Blue Coffeehouse','Blue Coffee','123'),
('Red Coffeehouse','Blue Coffee','224'),
('Green Coffeehouse','Blue Coffee','333'),
('Orange Coffeehouse','Orange Coffee','444'),
('Hot Coffeehouse','Blue Coffee','228'),
('Bad Coffeehouse','Red Coffee','288');
SELECT * FROM coffees;
SELECT * FROM sells;
UPDATE likes SET coffee = 'Bad Coffee' WHERE drinker= 'Tom Collins';
DELETE
FROM sells;
DELETE
FROM likes;
DELETE
FROM frequents;
DELETE
FROM drinkers;
DELETE
FROM coffees;
DELETE
FROM coffeehouses;
DROP TABLE sells;
DROP TABLE likes;
DROP TABLE frequents;
DROP TABLE drinkers;
DROP TABLE coffees;
DROP TABLE coffeehouses;