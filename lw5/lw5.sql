USE lab5;


-- 1. �������� ������� �����.
ALTER TABLE booking
    ADD CONSTRAINT booking_client_id_client_fk
        FOREIGN KEY (id_client) REFERENCES client (id_client)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE room
    ADD CONSTRAINT room_hotel_id_hotel_fk
        FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel)
            ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE room
    ADD CONSTRAINT room_room_category_id_room_category_fk
        FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE room_in_booking
    ADD CONSTRAINT room_in_booking_booking_id_booking_fk
        FOREIGN KEY (id_booking) REFERENCES booking (id_booking)
            ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE room_in_booking
    ADD CONSTRAINT room_in_booking_room_id_room_fk
        FOREIGN KEY (id_room) REFERENCES room (id_room)
            ON UPDATE CASCADE ON DELETE CASCADE;


-- 2. ������ ���������� � �������� ��������� �������, ����������� � ������� ��������� ����� �� 1 ������ 2019�.
SELECT c.name, c.phone
FROM client c
         INNER JOIN booking b ON c.id_client = b.id_client
         INNER JOIN room_in_booking rib
                    ON b.id_booking = rib.id_booking AND rib.checkin_date <= '2019-04-01' AND
                       '2019-04-01' < rib.checkout_date
         INNER JOIN room r ON rib.id_room = r.id_room
         INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = '������'
         INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category AND rc.name = '����';


-- 3. ���� ������ ��������� ������� ���� �������� �� 22 ������.
SELECT DISTINCT h.name AS hotel_name, r.number AS number, rc.name AS category, r.price AS price
FROM room r
         RIGHT JOIN room_in_booking rib ON r.id_room = rib.id_room AND
                                           NOT (rib.checkin_date <= '2019-04-22' AND '2019-04-22' < rib.checkout_date)
         INNER JOIN hotel h ON r.id_hotel = h.id_hotel
         INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category;


-- 4. ���� ���������� ����������� � ��������� ������� �� 23 ����� �� ������ ��������� �������
SELECT rc.name AS category_name, COUNT(c.id_client) AS residents_amount
FROM client c
         INNER JOIN booking b ON c.id_client = b.id_client
         INNER JOIN room_in_booking rib
                    ON b.id_booking = rib.id_booking AND rib.checkin_date <= '2019-03-23' AND
                       '2019-03-23' < rib.checkout_date
         INNER JOIN room r ON rib.id_room = r.id_room
         INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category
         INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = '������'
GROUP BY rc.name;


-- 5. ���� ������ ��������� ����������� �������� �� ���� �������� ��������� �������,
-- ��������� � ������ � ��������� ���� ������.
SELECT c.name, r.number, MAX(rib.checkout_date) AS checkout_date
FROM client c
         INNER JOIN booking b ON c.id_client = b.id_client
         INNER JOIN room_in_booking rib ON b.id_booking = rib.id_booking AND MONTH(rib.checkout_date) = 4
         INNER JOIN room r ON rib.id_room = r.id_room
         INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = '������'
GROUP BY r.number;



-- 6. �������� �� 2 ��� ���� ���������� � ��������� ������� ���� �������� ������
-- ��������� �������, ������� ���������� 10 ���.
UPDATE b
SET rib.checkout_date = DATEADD(DAY, 2, rib.checkout_date)
FROM booking b
INNER JOIN room_in_booking rib ON b.id_booking = rib.id_booking AND rib.checkin_date = '2019-05-10'
INNER JOIN room r ON rib.id_room = r.id_room
INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = '������'
INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category AND rc.name = '������'

SELECT c.name AS client_name, rib.checkout_date AS checkout_date
FROM client c
         INNER JOIN booking b ON c.id_client = b.id_client
         INNER JOIN room_in_booking rib ON b.id_booking = rib.id_booking AND rib.checkin_date = '2019-05-10'
         INNER JOIN room r ON rib.id_room = r.id_room
         INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = '������'
         INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category AND rc.name = '������';



-- 7. ����� ��� "��������������" �������� ����������. ���������� ���������: ��
-- ����� ���� ������������ ���� ����� �� ���� ���� ��������� ���, �.�. ������
-- ���������� ���������� �������� � ���� �����. ������ � �������
-- room_in_booking � id_room_in_booking = 5 � 2154 �������� ��������
-- ������������� ���������, ������� ���������� �����. �������������� ������
-- ������� ������ ��������� ���������� � ���� ������������� �������.
SELECT *
FROM room_in_booking rib1
         INNER JOIN room_in_booking rib2 ON rib1.id_room = rib2.id_room
WHERE rib1.id_room_in_booking <> rib2.id_room_in_booking
  AND rib1.checkin_date <= rib2.checkin_date
  AND rib1.checkout_date > rib2.checkout_date;


-- 8. ������� ������������ � ����������.
BEGIN TRAN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
DECLARE @client_id int = 9;
DECLARE @checkin_date date = '2022-04-22', @checkout_date date = '2022-05-22';
DECLARE @hotel_name varchar(255) = '������', @room_number int = 69;

INSERT INTO booking (id_client, booking_date)
VALUES (@client_id, GETDATE());

DECLARE @id_booking int = (SELECT TOP 1 id_booking
                   FROM booking
                   ORDER BY booking_date DESC);

DECLARE @id_room int = (SELECT TOP 1 r.id_room
                FROM room r
                         INNER JOIN hotel h ON r.id_hotel = h.id_hotel AND h.name = @hotel_name
                WHERE r.number = @room_number);

INSERT INTO room_in_booking (id_booking, id_room, checkin_date, checkout_date)
VALUES (SCOPE_IDENTITY(), @id_room, @checkin_date, @checkout_date);

-- ROLLBACK;
COMMIT TRAN;


-- 9. �������� ����������� ������� ��� ���� ������.
ALTER TABLE booking
    ADD INDEX booking_id_client_idx (id_client);

ALTER TABLE room_in_booking
    ADD INDEX room_in_booking_id_booking_idx (id_booking);
ALTER TABLE room_in_booking
    ADD INDEX room_in_booking_id_room_idx (id_room);

ALTER TABLE room
    ADD INDEX room_id_hotel_idx (id_hotel);
ALTER TABLE room
    ADD INDEX room_id_room_category_idx (id_room_category);