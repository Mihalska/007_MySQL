drop database MyFunkDB;
create database MyFunkDB;

use MyFunkDB;
create table Employees
(Employees_id int  not null PRIMARY KEY,
LName VARCHAR(50) NOT NULL ,
FName VARCHAR(50) NOT NULL ,
MName VARCHAR(50) NOT NULL ,
phone varchar(30) NOT NULL 
);
drop table Employees;

insert into Employees
( Employees_id, LName, FName, MName, phone )
 values 
(1, 'Іваненко', 'Іван', 'Іванович', '(093)025-41-45'),
(2, 'Шевченко', 'Олег', 'Іванович', '(095)825-46-69'),
(3, 'Ященко', 'Артем', 'Юрійович',  '(067)025-21-49'),  
(4, 'Кучера', 'Олена', 'Ігорівна',  '(097)036-41-87'); 
   
    
create table Salaryes
(salaryes_id int NOT NULL PRIMARY KEY,
position VARCHAR(50) NOT NULL,
salary int NOT NULL
);
    
ALTER TABLE Salaryes ADD CONSTRAINT
FK_Salaryes_Salaryes FOREIGN KEY(salaryes_id) 
	REFERENCES Employees(Employees_id)  ;
    
insert into Salaryes
( salaryes_id, position, salary)
 values  
 (1, 'Головний директор', 30000),
 (2, 'Менеджер', 20000),
 (3, 'Робітник_1', 15000),
 (4, 'Робітник_2', 13000);
   
create table Informations
(informations_id int NOT NULL PRIMARY KEY,
status VARCHAR(50) NOT NULL,
birthday date NOT NULL,
adress VARCHAR(50) NOT NULL
);
    
ALTER TABLE Informations ADD CONSTRAINT
FK_Informations_Informations FOREIGN KEY(informations_id) 
	REFERENCES Employees(Employees_id)  ;
   
insert into Informations
(informations_id, status, birthday, adress)
values
(1, 'Неодружений', '1985-11-25', 'вул. Васильківська, 35'),
(2, 'Одружений', '1986-01-15', 'вул. Миру, 100'),
(3, 'Неодружений', '1987-07-06', 'вул. Перемоги, 31/112'),
(4, 'Одружений', '1988-05-11', 'вул. Хрещатик, 45/100');
/*створюємо дві процедури. В першій при виклику CALL getAllEmployees()  записуємо дані у дві таблиці Result. */
DELIMITER |

DROP procedure getAllEmployees; |
CREATE PROCEDURE getAllEmployees()
BEGIN
    SELECT phone  FROM Employees;
    select adress FROM Informations;   
END
|

DELIMITER |
CALL getAllEmployees();|

/* В другій процедурі при виклику CALL getAllEmployees1()  записуємо дані у одну спільну таблицю Result. */

DROP procedure getAllEmployees1; |
CREATE PROCEDURE getAllEmployees1()
BEGIN
SELECT phone, (select adress from Informations where Employees.Employees_id=Informations.informations_id) as adress   FROM Employees;  
END
|
DELIMITER |
CALL getAllEmployees1();

|CREATE PROCEDURE clientsStatus ( IN cname nvarchar(25) )  
BEGIN
	select (select LName from Employees where Informations.informations_id= Employees.Employees_id) as LName,
   Informations.birthday, (select phone from Employees where Informations.informations_id= Employees.Employees_id) as phone
   from Informations
    
    WHERE status = cname;
END
|

DELIMITER |
CALL clientsStatus('Неодружений');
|

DELIMITER |

CREATE PROCEDURE positionAll (IN cname varchar(25) )

BEGIN
   IF (cname = 'Мен%')  
   THEN
	
	SELECT Employees.LName, Informations.birthday, Employees.phone  FROM Salaryes 
          inner join Informations on Salaryes.salaryes_id = Informations.informations_id 
          inner join Employees on Informations.informations_id= Employees.Employees_id
          WHERE position like cname; 
    ELSE				
	
	SELECT 'Bad error';
    END IF;
 END
|

DELIMITER |
CALL positionAll('Мен%');  |  

CALL positionAll('vi%');  
|
