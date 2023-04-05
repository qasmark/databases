USE lab6;

-- 1. �������� ������� �����.

ALTER TABLE dealer
    ADD CONSTRAINT fk_dealer_company FOREIGN KEY (id_company)
        REFERENCES company (id_company);

ALTER TABLE production
    ADD CONSTRAINT fk_production_company FOREIGN KEY (id_company)
        REFERENCES company (id_company);

ALTER TABLE production
    ADD CONSTRAINT fk_production_medicine FOREIGN KEY (id_medicine)
        REFERENCES medicine (id_medicine);

ALTER TABLE [order]
	ADD CONSTRAINT fk_order_production FOREIGN KEY (id_production)
		REFERENCES production (id_production);

ALTER TABLE [order]
	ADD CONSTRAINT fk_order_pharmacy FOREIGN KEY (id_pharmacy)
		REFERENCES pharmacy (id_pharmacy);

ALTER TABLE [order]
	ADD CONSTRAINT fk_order_dealer FOREIGN KEY (id_dealer)
		REFERENCES dealer (id_dealer);

-- 2. ������ ���������� �� ���� ������� ��������� ��������� �������� ������ � ��������� �������� �����, ���, ������ �������.

SELECT pharmacy.name, [order].date, [order].quantity 
FROM [order]
  LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
  LEFT JOIN production ON [order].id_production = production.id_production
  LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
  LEFT JOIN company ON production.id_company = company.id_company
  WHERE medicine.name = '��������' AND company.name = '�����';

-- 3. ���� ������ �������� �������� �������, �� ������� �� ���� ������� ������ �� 25 ������.

SELECT DISTINCT medicine.name
FROM medicine
         INNER JOIN production ON medicine.id_medicine = production.id_medicine
         INNER JOIN company ON production.id_company = company.id_company AND company.name = '�����'
         LEFT JOIN [order] ON production.id_production = [order].id_production AND [order].date < '2019-01-25'
WHERE [order].id_order IS NULL;


-- 4. ���� ����������� � ������������ ����� �������� ������ �����, ������� �������� �� ����� 120 �������.

SELECT company.name, MAX(production.rating) AS max_rating, MIN(production.rating) AS min_rating FROM company
  LEFT JOIN production ON company.id_company = production.id_company
  LEFT JOIN [order] ON production.id_production = [order].id_production
  GROUP BY company.name
  HAVING COUNT([order].id_order) >= 120;

-- 5. ���� ������ ��������� ������ ����� �� ���� ������� �������� �AstraZeneca�. ���� � ������ ��� �������, � �������� ������ ���������� NULL.

SELECT distinct dealer.name, pharmacy.name FROM dealer
  LEFT JOIN company ON dealer.id_company = company.id_company
  LEFT JOIN [order] ON dealer.id_dealer = [order].id_dealer
  LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
  WHERE company.name = 'AstraZeneca'

-- 6. ��������� �� 20% ��������� ���� ��������, ���� ��� ��������� 3000, � ������������ ������� �� ����� 7 ����.

UPDATE production SET production.price = production.price * 0.8 FROM production
  LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
  WHERE production.price > 3000 AND medicine.cure_duration <= 7;

-- ��������
SELECT production.price FROM production
  LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
  WHERE production.price > 3000 AND medicine.cure_duration <= 7;

-- 7. �������� ����������� �������.

CREATE INDEX IX_medicine_name ON medicine (name);
CREATE INDEX IX_company_name ON company (name);
CREATE INDEX IX_order_date ON [order] (date);
CREATE INDEX IX_production_price ON production (price);
CREATE INDEX IX_medicine_cure_duration ON medicine (cure_duration);