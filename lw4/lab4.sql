USE lab4;

-- 3.1 INSERT

-- 3.1a ��� �������� ������ �����
INSERT INTO client
VALUES ('John', 'Doe', 'Yoshkar-Ola, Voznesenskaya, 110', '504-805-111', 'johddoe@gm.com'),
	   ('Jane', 'Doe', 'Yoshkar-Ola, Voznesenskaya, 111', '504-805-112', 'janedoe@gm.com');

-- 3.1b � ��������� ������ �����
INSERT INTO employee (first_name, second_name, job_position, salary)
VALUES ('Oleg', 'Ivanov', 'Sales associate', 25000);
	
-- 3.1c � ������� �������� �� ������ �������
INSERT INTO employee (first_name, second_name, job_position, salary)
SELECT first_name, second_name, 'Intern', 25000
FROM client
WHERE id_client = 1;


-- 3.2 DELETE

-- 3.2a ���� �������
-- noinspection SqlWithoutWhere
DELETE 
FROM inventory;

-- 3.2b �� �������
DELETE
FROM employee
WHERE salary = 20000;


-- 3.3 UPDATE

-- 3.3a ���� �������
UPDATE client
SET first_name = 'John';

-- 3.3b �� ������� �������� ���� �������
UPDATE inventory
SET rental_price = 500
WHERE quantity_avaliable > 20;

-- 3.3c �� ������� �������� ��������� ���������
UPDATE employee
SET salary = 30000,
	job_position = 'Intern'
WHERE first_name = 'Oleg';


-- 3.4 SELECT

-- 3.4a � ������� ����������� ���������
SELECT first_name, second_name
FROM client;

-- 3.4b �� ����� ����������
SELECT *
FROM inventory;

-- 3.4c � �������� �� ��������
SELECT  *
FROM inventory
WHERE rental_price > 800;


-- 3.5 SELECT ORDER BY + TOP (LIMIT)

-- 3.5a � ����������� �� ����������� ASC + ����������� ������ ���������� �������
SELECT TOP 5 * 
FROM employee
ORDER BY salary ASC;

-- 3.5b � ����������� �� �������� DESC
SELECT *
FROM inventory
ORDER BY rental_price DESC;
-- 3.5c � ����������� �� ���� ��������� + ����������� ������ ���������� �������
SELECT TOP 5 *
FROM rental
ORDER BY due_date DESC, rental_fee;

-- 3.5d � ����������� �� ������� ��������, �� ������ �����������
SELECT salary, job_position
FROM employee
ORDER BY 1;


-- 3.6 ������ � ������

-- 3.6a WHERE �� ����
SELECT *
FROM rental
WHERE rental_date = '2023-01-15';

-- 3.6b WHERE ���� � ���������
SELECT *
FROM sale
WHERE sale_date BETWEEN '2023-02-03' AND '2023-24-03';

-- 3.6c ������� �� ������� �� ��� ����, � ������ ���
SELECT id_client, YEAR(rental_date) AS rental_date
FROM rental;



-- 3.7 ������� ���������

-- 3.7a ��������� ���������� ������� � �������
SELECT COUNT(*) AS amount_of_employees
FROM employee;

-- 3.7b ��������� ���������� ���������� ������� � �������
SELECT COUNT(DISTINCT first_name) AS amount_of_employees_with_uneque_name
FROM employee;

-- 3.7c ������� ���������� �������� �������
SELECT DISTINCT first_name
FROM client;

-- 3.7d ����� ������������ �������� �������
SELECT MAX(salary) AS max_salary
FROM employee;

-- 3.7e ����� ����������� �������� �������
SELECT MIN(salary) AS min_salary
FROM employee;

-- 3.7f �������� ������ COUNT() + GROUP BY
SELECT first_name, COUNT(*) AS  uneque_names
FROM client
GROUP BY first_name;

-- 3.8 SELECT GROUP BY + HAVING

-- 3.8a �������� 3 ������ ������� � �������������� GROUP BY + HAVING. ���
-- ������� ������� �������� ����������� � ����������, ����� ����������
-- ��������� ������. ������ ������ ���� �����������, �.�. �������� ����������,
-- ������� ����� ������������.


-- ���������� ����� � ���������� ���������
SELECT salary, COUNT(*) as amount
FROM employee
GROUP BY salary 
HAVING COUNT(*) > 1


-- ���������� ������ � ���������� ����������
SELECT total_amount, COUNT(*) as amount
FROM sale
GROUP BY total_amount
HAVING COUNT(*) > 1;

-- ��������, ������������ �� ��� ������ � ���������� ������ 3000
SELECT due_date, AVG(rental_fee) as average_rental_fee
FROM rental
WHERE due_date = 14
GROUP BY due_date, rental_fee
HAVING AVG(rental_fee) < 3500;


-- 3.9 SELECT JOIN

-- 3.9a LEFT JOIN ���� ������ � WHERE �� ������ �� ���������

SELECT c.id_client, r.id_client 
FROM rental r
	LEFT JOIN  client c ON	c.id_client = r.id_client;

-- 3.9b RIGHT JOIN. �������� ����� �� �������, ��� � � 3.9a
SELECT c.id_client, r.id_client
FROM client c
	RIGHT JOIN rental  r ON r.id_client = c.id_client;

-- 3.9c LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������
SELECT e.first_name, e.second_name
FROM employee e
	LEFT JOIN sale s ON s.id_employee =  e.id_employee
	LEFT JOIN client c ON c.first_name = e.first_name 

-- 3.9d INNER JOIN ���� ������
SELECT c.first_name
FROM employee e
	INNER JOIN client c ON e.first_name =c.first_name;


-- 3.10 ����������

-- 3.10a �������� ������ � �������� WHERE IN (���������)
SELECT *
FROM client
WHERE id_client IN (SELECT id_client FROM employee WHERE client.first_name = employee.first_name);

-- 3.10b �������� ������ SELECT atr1, atr2, (���������) FROM ...
SELECT i.name, i.rental_price, (SELECT AVG(r.rental_fee) FROM rental r) AS average_price
FROM inventory i;

-- 3.10c �������� ������ ���� SELECT * FROM (���������)
SELECT *
FROM (
	SELECT c.first_name
	FROM client c
) AS client_name
WHERE client_name.first_name IN ( 'Sanya', 'Oleg');

-- 3.10d �������� ������ ���� SELECT * FROM table JOIN (���������) ON ...
SELECT *
FROM rental r
JOIN (
	SELECT i.rental_price , AVG(rental_price) AS average_rental_price
	FROM inventory i
	GROUP BY i.rental_price
	) AS total ON r.rental_fee = total.rental_price;
