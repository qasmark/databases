USE lab4;

-- 3.1 INSERT

-- 3.1a Без указания списка полей
INSERT INTO client
VALUES ('John', 'Doe', 'Yoshkar-Ola, Voznesenskaya, 110', '504-805-111', 'johddoe@gm.com'),
	   ('Jane', 'Doe', 'Yoshkar-Ola, Voznesenskaya, 111', '504-805-112', 'janedoe@gm.com');

-- 3.1b С указанием списка полей
INSERT INTO employee (first_name, second_name, job_position, salary)
VALUES ('Oleg', 'Ivanov', 'Sales associate', 25000);
	
-- 3.1c С чтением значения из другой таблицы
INSERT INTO employee (first_name, second_name, job_position, salary)
SELECT first_name, second_name, 'Intern', 25000
FROM client
WHERE id_client = 1;


-- 3.2 DELETE

-- 3.2a Всех записей
-- noinspection SqlWithoutWhere
DELETE 
FROM inventory;

-- 3.2b По условию
DELETE
FROM employee
WHERE salary = 20000;


-- 3.3 UPDATE

-- 3.3a Всех записей
UPDATE client
SET first_name = 'John';

-- 3.3b По условию обновляя один атрибут
UPDATE inventory
SET rental_price = 500
WHERE quantity_avaliable > 20;

-- 3.3c По условию обновляя несколько атрибутов
UPDATE employee
SET salary = 30000,
	job_position = 'Intern'
WHERE first_name = 'Oleg';


-- 3.4 SELECT

-- 3.4a С набором извлекаемых атрибутов
SELECT first_name, second_name
FROM client;

-- 3.4b Со всеми атрибутами
SELECT *
FROM inventory;

-- 3.4c С условием по атрибуту
SELECT  *
FROM inventory
WHERE rental_price > 800;


-- 3.5 SELECT ORDER BY + TOP (LIMIT)

-- 3.5a С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 5 * 
FROM employee
ORDER BY salary ASC;

-- 3.5b С сортировкой по убыванию DESC
SELECT *
FROM inventory
ORDER BY rental_price DESC;
-- 3.5c С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 5 *
FROM rental
ORDER BY due_date DESC, rental_fee;

-- 3.5d С сортировкой по первому атрибуту, из списка извлекаемых
SELECT salary, job_position
FROM employee
ORDER BY 1;


-- 3.6 Работа с датами

-- 3.6a WHERE по дате
SELECT *
FROM rental
WHERE rental_date = '2023-01-15';

-- 3.6b WHERE дата в диапазоне
SELECT *
FROM sale
WHERE sale_date BETWEEN '2023-02-03' AND '2023-24-03';

-- 3.6c Извлечь из таблицы не всю дату, а только год
SELECT id_client, YEAR(rental_date) AS rental_date
FROM rental;



-- 3.7 Функции агрегации

-- 3.7a Посчитать количество записей в таблице
SELECT COUNT(*) AS amount_of_employees
FROM employee;

-- 3.7b Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT first_name) AS amount_of_employees_with_uneque_name
FROM employee;

-- 3.7c Вывести уникальные значения столбца
SELECT DISTINCT first_name
FROM client;

-- 3.7d Найти максимальное значение столбца
SELECT MAX(salary) AS max_salary
FROM employee;

-- 3.7e Найти минимальное значение столбца
SELECT MIN(salary) AS min_salary
FROM employee;

-- 3.7f Написать запрос COUNT() + GROUP BY
SELECT first_name, COUNT(*) AS  uneque_names
FROM client
GROUP BY first_name;

-- 3.8 SELECT GROUP BY + HAVING

-- 3.8a Написать 3 разных запроса с использованием GROUP BY + HAVING. Для
-- каждого запроса написать комментарий с пояснением, какую информацию
-- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
-- которую можно использовать.


-- Количество людей с одинаковой зарплатой
SELECT salary, COUNT(*) as amount
FROM employee
GROUP BY salary 
HAVING COUNT(*) > 1


-- Количество продаж с одинаковой стоимостью
SELECT total_amount, COUNT(*) as amount
FROM sale
GROUP BY total_amount
HAVING COUNT(*) > 1;

-- Инветарь, арендованный на две недели и стоимостью больше 3000
SELECT due_date, AVG(rental_fee) as average_rental_fee
FROM rental
WHERE due_date = 14
GROUP BY due_date, rental_fee
HAVING AVG(rental_fee) < 3500;


-- 3.9 SELECT JOIN

-- 3.9a LEFT JOIN двух таблиц и WHERE по одному из атрибутов

SELECT c.id_client, r.id_client 
FROM rental r
	LEFT JOIN  client c ON	c.id_client = r.id_client;

-- 3.9b RIGHT JOIN. Получить такую же выборку, как и в 3.9a
SELECT c.id_client, r.id_client
FROM client c
	RIGHT JOIN rental  r ON r.id_client = c.id_client;

-- 3.9c LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT e.first_name, e.second_name
FROM employee e
	LEFT JOIN sale s ON s.id_employee =  e.id_employee
	LEFT JOIN client c ON c.first_name = e.first_name 

-- 3.9d INNER JOIN двух таблиц
SELECT c.first_name
FROM employee e
	INNER JOIN client c ON e.first_name =c.first_name;


-- 3.10 Подзапросы

-- 3.10a Написать запрос с условием WHERE IN (подзапрос)
SELECT *
FROM client
WHERE id_client IN (SELECT id_client FROM employee WHERE client.first_name = employee.first_name);

-- 3.10b Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT i.name, i.rental_price, (SELECT AVG(r.rental_fee) FROM rental r) AS average_price
FROM inventory i;

-- 3.10c Написать запрос вида SELECT * FROM (подзапрос)
SELECT *
FROM (
	SELECT c.first_name
	FROM client c
) AS client_name
WHERE client_name.first_name IN ( 'Sanya', 'Oleg');

-- 3.10d Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON ...
SELECT *
FROM rental r
JOIN (
	SELECT i.rental_price , AVG(rental_price) AS average_rental_price
	FROM inventory i
	GROUP BY i.rental_price
	) AS total ON r.rental_fee = total.rental_price;
