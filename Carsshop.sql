
 DELIMITER |
 drop database carsshop; |

create database carsshop; |

use carsshop; |
 
 create table marks(
   id int not null auto_increment primary key,
   mark varchar(20) unique
); |

create table cars(
  id INT NOT NULL auto_increment primary key,
  mark_id INT NOT NULL,
  model varchar(20) NOT NULL,
  price INT NOT NULL,
  foreign key(mark_id) references marks(id)
); |

CREATE TABLE clients
(
	
	 id INT AUTO_INCREMENT NOT NULL,
     name VARCHAR(30),
     age TINYINT,
     phone VARCHAR(15),
     PRIMARY KEY (id)
); |

create table orders(
     id int not null primary key auto_increment,
     car_id int not null,
     client_id int not null,
     foreign key(car_id) references cars(id),
     foreign key(client_id) references clients(id)
); |

INSERT into marks(mark) values('Audi');|
INSERT into marks(mark) values('Porsche'); |

insert into cars(mark_id, model, price) values (1, 'A5', 50000); |
insert into cars(mark_id, model, price) values (2, 'panamera', 100000); |
insert into cars(mark_id, model, price) values (2, 'caymen S', 88000); |

insert into clients(name, age) values ('petro', 20), ('vasya', 25), ('vitaly', 75); |

insert into orders(car_id, client_id) values(1, 1), (2, 2), (1, 3); |

 /* створюємо функцію для знаходження мінімального віку клiента */   
use carsshop; |

DELIMITER |

CREATE FUNCTION MinAge() 
RETURNS INT
deterministic
BEGIN
    RETURN (SELECT MIN(age) FROM clients );   
	END
| 
SELECT  MinAge() ;|
DELIMITER |



/* Зробимо вибірку машин, які придбав клієнт з мінімальним віком. 
Відповідно виводимо в таблиці імя, його вік (позначили як minAge), модель машини та марку, яку/які він придбав */
    
SELECT name, age as minAge, (SELECT model FROM cars
WHERE id = (SELECT car_id FROM orders
			WHERE orders.client_id = clients.id ))  AS model,
           
           (SELECT mark FROM marks
WHERE id = (select mark_id from cars WHERE cars.mark_id = (SELECT car_id FROM orders
			WHERE orders.client_id = clients.id ))) as mark 

from clients WHERE age = MinAge();

/* Створюємо функцію для знаходження мінімального віку клiента, згрупувавши по машинам-
 тобто який найменший вік покупця, який придбав дану марку машини. */   
DELIMITER |

CREATE FUNCTION MinAge1 (mark varchar(20)) 
RETURNS INT
deterministic
BEGIN


    RETURN (SELECT  Min(clients.age) FROM clients 
            INNER JOIN orders  ON orders.client_id = clients.id
			INNER JOIN cars  ON cars.id = orders.car_id 
            INNER JOIN marks  ON marks.id = cars.mark_id  WHERE marks.mark = mark  );           
	END
| 


SELECT  mark, MinAge1(mark) from marks  ;|
/* або ми вносимо марку і бачимо якого найменшого віку  покупець цю марку купував*/
SELECT   MinAge1('Audi') ;|

drop FUNCTION MinAge1; |


