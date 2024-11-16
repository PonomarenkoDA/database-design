
--!!! Версия СУБД PostgreSQL 17 !!!

CREATE TABLE repair_service 
	(date date, -- дата
	service text, -- регион расположения сервиса
	service_addr text, -- адресс сервиса
	w_name text, -- имя сотрудника
	w_exp integer, -- опыт сотрудника
	w_phone text, -- номер телефона сотрудника
	wages integer, -- зарплата сотрудника
	card text, -- номер карты клиента
	payment text, -- стоимость заказа клиента
	pin text, -- пинкод карты клиента
	name text, -- имя клиента
	phone text, -- телефон клиента 
	email text, --  email-адресс (логин от личного кабинета) клиента
	password text, -- пароль от личного кабинета клиента
	car text, -- марка машины клиента
	mileage text, -- пробег в милях
	vin text, -- вин-номер
	car_number text, -- номер машины
	color text -- цвет машины
);

---------------КОЛИЧЕСТВО NULL значений----------------

SELECT -- Подсчет количества NULL значений
	COUNT(*) FILTER (WHERE date IS NULL) AS date,
	COUNT(*) FILTER (WHERE service IS NULL) AS service,
	COUNT(*) FILTER (WHERE service_addr IS NULL) AS service_addr,
	COUNT(*) FILTER (WHERE w_name IS NULL) AS w_name,
	COUNT(*) FILTER (WHERE w_exp IS NULL) AS w_exp,
	COUNT(*) FILTER (WHERE w_phone IS NULL) AS w_phone,
	COUNT(*) FILTER (WHERE wages IS NULL) AS wages,
	COUNT(*) FILTER (WHERE card IS NULL) AS card,
	COUNT(*) FILTER (WHERE payment IS NULL) AS payment,
	COUNT(*) FILTER (WHERE pin IS NULL) AS pin,
	COUNT(*) FILTER (WHERE name IS NULL) AS name,
	COUNT(*) FILTER (WHERE phone IS NULL) AS phone,
	COUNT(*) FILTER (WHERE email IS NULL) AS email,
	COUNT(*) FILTER (WHERE password IS NULL) AS password,
	COUNT(*) FILTER (WHERE car IS NULL) AS car,
	COUNT(*) FILTER (WHERE mileage IS NULL) AS mileage,
	COUNT(*) FILTER (WHERE vin IS NULL) AS vin,
	COUNT(*) FILTER (WHERE car_number IS NULL) AS car_number,
	COUNT(*) FILTER (WHERE color IS NULL) AS color
FROM repair_service rs;

--Колонки:  date service service_addr  w_name   w_exp   w_phone  wages  card   payment  pin    name   phone   email   password  car    mileage   vin  car_number  color
--Результат: 0	  46893	    46448	    23232	23310	23199	23600	31090	30939	31312	10329	10143	10532	10351	10357	10332	10314	10571	10412

----------------КОЛИЧЕСТВО UNIQ значений-----------------

SELECT -- Подсчет уникальных значений
	COUNT(DISTINCT date) AS cnt_date,
	COUNT(DISTINCT service) AS cnt_service,
	COUNT(DISTINCT service_addr) AS cnt_service_addr,
	COUNT(DISTINCT w_name) AS cnt_w_name,
	COUNT(DISTINCT w_exp) AS cnt_w_exp,
	COUNT(DISTINCT w_phone) AS cnt_w_phone,
	COUNT(DISTINCT wages) AS cnt_wages,
	COUNT(DISTINCT card) AS cnt_card,
	COUNT(DISTINCT payment) AS cnt_payment,
	COUNT(DISTINCT pin) AS cnt_pin,
	COUNT(DISTINCT name) AS cnt_name,
	COUNT(DISTINCT phone) AS cnt_phone,
	COUNT(DISTINCT email) AS cnt_email,
	COUNT(DISTINCT password) AS cnt_password,
	COUNT(DISTINCT car) AS cnt_car,
	COUNT(DISTINCT mileage) AS cnt_mileage,
	COUNT(DISTINCT vin) AS cnt_vin,
	COUNT(DISTINCT car_number) AS cnt_car_number,
	COUNT(DISTINCT color) AS cnt_color
FROM repair_service rs;

--Колонки:  date service service_addr  w_name   w_exp   w_phone  wages  card   payment  pin    name   phone   email   password  car    mileage   vin  car_number  color
--Результат: 4265	6		6			34		18		34		  34	57011	55617	9966	524	   524	   524		524		42		73809	  524	524			24

---------------Заполняем пропуски в таблицах----------------

SELECT * --Посмотрим на исходную таблицу
FROM repair_service
ORDER BY date


--№1 Сотрудники автосервиса

UPDATE repair_service AS t1 -- Заполним пропуски в именах (Сотрудники автосервиса)
SET w_name = sb.w_name
FROM (
	SELECT DISTINCT
		w_name,
		w_phone
	FROM repair_service
	WHERE w_name IS NOT NULL
		AND w_phone IS NOT NULL
	) AS sb
WHERE t1.w_phone = sb.w_phone

UPDATE repair_service AS t2 -- Заполним пропуски в остальных колонках (Сотрудники автосервиса)
SET wages = sb.wages,
	w_phone = sb.w_phone, 
	w_exp = sb.w_exp
FROM (
	SELECT DISTINCT
		w_name,
		wages,
		w_phone,
		w_exp
	FROM repair_service
	WHERE wages IS NOT NULL
		AND w_exp IS NOT NULL
		AND w_phone IS NOT NULL 
) AS sb
WHERE t2.w_name = sb.w_name

--№2 Клиенты автосервиса

UPDATE repair_service AS t1 -- Заполним пропуски в именах (Клиенты автосервиса)
SET name = sb.name
FROM (
	SELECT DISTINCT 
		name,
		email
	FROM repair_service
	WHERE name IS NOT NULL
		AND email IS NOT NULL
	) AS sb
WHERE t1.email = sb.email

UPDATE repair_service AS t2 -- Заполним пропуски в остальных колонках (Клиенты автосервиса)
SET phone = sb.phone,
	email = sb.email, 
	password = sb.password
FROM (
	SELECT DISTINCT
		name,
		phone,
		email,
		password
	FROM repair_service
	WHERE phone IS NOT NULL
		AND email IS NOT NULL
		AND password IS NOT NULL 
) AS sb
WHERE t2.name = sb.name

--№3 Машины клиентов

UPDATE repair_service AS t1 -- Заполним пропуски в vin номерах (Машины клиентов)
SET vin = sb.vin
FROM (
	SELECT DISTINCT 
		vin,
		car_number
	FROM repair_service
	WHERE vin IS NOT NULL
		AND car_number IS NOT NULL
) AS sb
WHERE t1.car_number = sb.car_number

UPDATE repair_service AS t2 -- Заполним пропуски в остальных колонках (Машины клиентов)
SET car_number = sb.car_number,
	color = sb.color, 
	car = sb.car
FROM (
	SELECT DISTINCT
		vin,
		car_number,
		color,
		car
	FROM repair_service
	WHERE car_number IS NOT NULL
		AND color IS NOT NULL
		AND car IS NOT NULL  
) AS sb
WHERE t2.vin = sb.vin

--№4 Адреса расположения автосервисов

UPDATE repair_service AS t1 -- Заполним пропуски (расположения автосервисов)
SET service = sb.service
FROM (
	SELECT DISTINCT
		service,
		w_name
	FROM repair_service
	WHERE service IS NOT NULL
) AS sb
WHERE t1.w_name = sb.w_name

UPDATE repair_service AS t2 -- Заполним пропуски в остальных колонках (расположения автосервисов)
SET service_addr = sb.service_addr
FROM (
	SELECT DISTINCT
		service_addr,
		w_name
	FROM repair_service
	WHERE service_addr IS NOT NULL
) AS sb
WHERE t2.w_name = sb.w_name
 

SELECT * --Посмотрим на получившуюся таблицу
FROM repair_service
ORDER BY date


-----------------Убираем дубликаты------------------------------

CREATE TABLE IF NOT EXISTS cleaned_repair_service AS -- Избавляемся от полных дубликатов и оставшихся NULL значений (заменой на значение по умолчанию)
	SELECT DISTINCT
		date,
		service,
		service_addr,
		w_name,
		w_exp,
		w_phone,
		wages,
		COALESCE(card, 'Неизвестно') AS card,
		COALESCE(payment, 'Неизвестно') AS payment,
		COALESCE(pin, 'Неизвестно') AS pin,
		name,
		phone,
		email,
		password,
		car,
		COALESCE(mileage, 'Неизвестно') AS mileage,
		vin,
		car_number,
		color
	FROM repair_service rs 
	
SELECT * --Посмотрим на получившуюся таблицу
FROM cleaned_repair_service

---------------КОЛИЧЕСТВО NULL значений----------------

--Колонки:  date service service_addr  w_name   w_exp   w_phone  wages  card   payment  pin    name   phone   email   password  car    mileage   vin  car_number  color
--Результат: 0		0		0			0		0		0		0		0		0		0		0		0		0		0		0		0		0		0			0

----------------КОЛИЧЕСТВО UNIQ значений-----------------

--Колонки:  date service service_addr  w_name   w_exp   w_phone  wages  card   payment  pin    name   phone   email   password  car    mileage   vin  car_number  color
--Результат: 4265	6		6			34		18		34		  34	57011	55617	9966	524	   524	   524		524		42		73809	  524	524			24

--ВЫВОД: заполнение NULL значений и удаление дубликатов проведено успешно -> сохранились все уникальные значения в колонках 



-----------------НОРМАЛИЗАЦИЯ ТАБЛИЦЫ (до 3 НФ)-----------------------------

--№1 Адреса расположения автосервисов

CREATE TABLE IF NOT EXISTS services AS --Таблица с информацией о всех автосервисах
	SELECT DISTINCT
		service,
		service_addr
	FROM cleaned_repair_service;

ALTER TABLE services -- создание автоинкрементного столбца
ADD COLUMN service_id SERIAL PRIMARY KEY;
	
SELECT *
FROM services

--№2 Сотрудники автосервиса

CREATE TABLE IF NOT EXISTS workers ( --Таблица с информацией о cотрудниках автосервиса
	worker_id SERIAL PRIMARY KEY,
	worker_name text,
	worker_surname text,
	worker_exp integer,
	worker_phone text,
	wages integer,
	service_id integer REFERENCES services(service_id)
);

INSERT INTO workers (worker_name, worker_surname, worker_exp, worker_phone, wages, service_id)
	SELECT DISTINCT
		SPLIT_PART(w_name,' ', 1),
		SPLIT_PART(w_name,' ', 2),
		w_exp,
		w_phone,
		wages,
		(SELECT service_id FROM services WHERE service_addr = tb.service_addr)
	FROM cleaned_repair_service AS tb
	
SELECT *
FROM workers

--№3 Клиенты автосервиса

CREATE TABLE IF NOT EXISTS clients AS --Таблица с информацией о клиентах автосервиса
	SELECT DISTINCT
		SPLIT_PART(name,' ', 1) AS client_name,
		SPLIT_PART(name,' ', 2) AS client_surname,
		phone AS client_phone,
		email AS client_login,
		password AS client_password
	FROM cleaned_repair_service;

ALTER TABLE clients -- создание автоинкрементного столбца
ADD COLUMN client_id SERIAL PRIMARY KEY;

SELECT *
FROM clients

--№4 Машины клиентов

CREATE TABLE IF NOT EXISTS cars (
	car_id SERIAL PRIMARY KEY,
	car text,
	vin text,
	car_number text,
	color text,
	client_id integer REFERENCES clients(client_id)
);

INSERT INTO cars (car, vin, car_number, color, client_id)
	SELECT DISTINCT
		car,
		vin,
		car_number,
		color,
		(SELECT client_id FROM clients WHERE client_name = SPLIT_PART(tb.name, ' ', 1) 
										AND client_surname = SPLIT_PART(tb.name, ' ', 2))
	FROM cleaned_repair_service AS tb
	
SELECT *
FROM cars


--№5 Карты клиентов

CREATE TABLE IF NOT EXISTS cards AS --Таблица с информацией о картах клиентов
	SELECT DISTINCT
		card,
		pin
	FROM cleaned_repair_service
	WHERE card != 'Неизвестно';

ALTER TABLE cards -- создание автоинкрементного столбца
ADD COLUMN card_id SERIAL PRIMARY KEY;

--Примечание

SELECT ROUND(AVG(cnt_card), 2) -- в среднем на одного человека приходится ~110 карт
FROM (SELECT 
		name,
		COUNT(DISTINCT card) AS cnt_card
	FROM cleaned_repair_service crs 
	GROUP BY name);

SELECT -- на одного человека приходится несколько карт с одинаковым пином
	name,
	pin,
	COUNT(DISTINCT card) AS cnt_card
FROM cleaned_repair_service
WHERE pin != 'Неизвестно'
GROUP BY name, pin
ORDER BY cnt_card DESC

--Конец примечания

INSERT INTO cards (card_id, card, pin)
VALUES (0, 'Неизвестно', 'Неизвестно')

--Примем информацию о пин-коде клиента неизвестной, если в заказе неизвестен номер карты (по причине ниже)
--Поскольку восстановить информацию о карте по пин-коду невозможно (у каждого клиента около ~110 карт и пин-коды могут повторятся у одного владельца)
--Так мы получим логически связанную таблицу с платежной информацией клиентов (карта + пин)

SELECT *
FROM cards

--№5 Информация о заказах

CREATE TABLE IF NOT EXISTS orders (--Таблица с информацией о заказах
	order_id SERIAL PRIMARY KEY,
	date date,
	payment text,
	mileage text,
	car_id integer references cars(car_id),
	worker_id integer references workers(worker_id),
	card_id integer references cards(card_id)
);

INSERT INTO orders (date, payment, mileage, car_id, worker_id, card_id)
	SELECT
		date,
		payment,
		mileage,
		(SELECT car_id FROM cars WHERE vin = tb.vin),
		(SELECT worker_id FROM workers WHERE worker_name = SPLIT_PART(tb.w_name, ' ', 1) 
										AND worker_surname = SPLIT_PART(tb.w_name, ' ', 2)),
		COALESCE((SELECT card_id FROM cards WHERE card = tb.card), 0)
	FROM cleaned_repair_service AS tb
	
SELECT --Проверка целостности уникальных значений
	COUNT(DISTINCT date),
	COUNT(DISTINCT payment),
	COUNT(DISTINCT mileage),
	COUNT(DISTINCT car_id),
	COUNT(DISTINCT worker_id),
	COUNT(DISTINCT card_id)
FROM orders

SELECT --Проверка отсутствия NULL значений
	COUNT(date) FILTER (WHERE date IS NULL),
	COUNT(payment) FILTER (WHERE payment IS NULL),
	COUNT(mileage) FILTER (WHERE mileage IS NULL),
	COUNT(car_id) FILTER (WHERE car_id IS NULL),
	COUNT(worker_id) FILTER (WHERE worker_id IS NULL),
	COUNT(card_id) FILTER (WHERE card_id IS NULL)
FROM orders

SELECT *
FROM orders

-----------------ИНДЕКСАЦИЯ (METHOD=BTREE)--------------------

CREATE INDEX service_idx ON services (service);
CREATE INDEX name_worker_idx ON workers (worker_name, worker_surname);
CREATE INDEX name_client_idx ON clients (client_name, client_surname);
CREATE INDEX card_idx ON cards (card);
CREATE INDEX car_idx ON cars (car);
CREATE INDEX order_date_idx ON orders (date);

-----------------Удаление лишних таблиц-----------------------

DROP TABLE repair_service, cleaned_repair_service 

-------------------Основные задания---------------------------

--1. Создать таблицу скидок и дать скидку самым частым клиентам: 10% скидка для топ 10 клиентов, 5% для топ 100 клиентов

SELECT -- Каждому клиенту соответсвует одна машина
	client_id,
	COUNT(DISTINCT car_id) cnt_cars
FROM cars
GROUP BY client_id 
ORDER BY cnt_cars DESC

SELECT -- В среднем у каждого клиента ~ 163 заказа
	ROUND(AVG(cnt_orders), 2) avg_orders_client
FROM (
	SELECT
		car_id,
		COUNT(order_id) cnt_orders
	FROM orders
	GROUP BY car_id
	ORDER BY cnt_orders DESC
)

CREATE TABLE IF NOT EXISTS discounts (
	discount_id SERIAL PRIMARY KEY,
	percent_discount integer,
	client_id integer references clients(client_id)
);

INSERT INTO discounts (client_id, percent_discount)
	SELECT client_id,
		CASE
			WHEN ROW_NUMBER() OVER (ORDER BY cnt_orders DESC) <= 10 THEN 10
			WHEN ROW_NUMBER() OVER (ORDER BY cnt_orders DESC) <= 100 THEN 5
			ELSE 0
		END AS percent_discount
	FROM (
		SELECT
			client_id,
			COUNT(order_id) cnt_orders
		FROM orders AS r
		LEFT JOIN cars AS l
			USING(car_id)
		GROUP BY client_id
		) AS table_cnt_orders

	SELECT *
	FROM discounts

	
--2. Поднять зарплату трем самым результативным механикам на 10%
	
SELECT
	worker_id,
	wages,
	COUNT(order_id) AS cnt_orders
FROM orders AS r
LEFT JOIN workers AS l
	USING(worker_id)
GROUP BY worker_id, wages
ORDER BY cnt_orders DESC
LIMIT 3

UPDATE workers AS t1
SET wages = sb.wages
FROM (
	SELECT
		worker_id,
		wages * 1.1 AS wages,
		COUNT(order_id) AS cnt_orders
	FROM orders AS r
	LEFT JOIN workers AS l
		USING(worker_id)
	GROUP BY worker_id, wages
	ORDER BY cnt_orders DESC
	LIMIT 3
) AS sb
WHERE t1.worker_id = sb.worker_id

--3.Сделать представление для директора: филиал, количество заказов за последний месяц,
--  заработанная сумма, заработанная сумма за вычетом зарплат

CREATE VIEW last_month_results AS 
	SELECT
		service,
		service_addr,
		COUNT(order_id) AS cnt_orders,
		SUM(payment::int) FILTER (WHERE payment <> 'Неизвестно') AS revenue,
		SUM(payment::int) FILTER (WHERE payment <> 'Неизвестно') - SUM(wages) AS profit
	FROM orders AS t1
	LEFT JOIN workers AS t2
		USING(worker_id)
	LEFT JOIN services AS t3
		USING(service_id)
	WHERE DATE_TRUNC('month', date)::date = (SELECT MAX(DATE_TRUNC('month', date))::date FROM orders)
	GROUP BY service, service_addr
	ORDER BY profit DESC;

SELECT *
FROM last_month_results

--4.Сделать рейтинг самых надежных и ненадежных авто

WITH orders_by_car AS ( -- Самые надежные (меньше всего ломались)
	SELECT
		car_id,
		car,
		COUNT(order_id) cnt_orders
	FROM orders AS t1
	LEFT JOIN cars AS t2
		USING (car_id)
	GROUP BY car_id, car
	ORDER BY cnt_orders
)
SELECT
	ROW_NUMBER() OVER (ORDER BY avg_orders_by_car) AS rating,
	car AS reliable_car
FROM (
	SELECT
		car,
		ROUND(AVG(cnt_orders), 1) AS avg_orders_by_car
	FROM orders_by_car
	GROUP BY car
);


WITH orders_by_car AS ( -- Самые ненадежные (больше всего ломались)
	SELECT
		car_id,
		car,
		COUNT(order_id) cnt_orders
	FROM orders AS t1
	LEFT JOIN cars AS t2
		USING (car_id)
	GROUP BY car_id, car
	ORDER BY cnt_orders
)
SELECT
	ROW_NUMBER() OVER (ORDER BY avg_orders_by_car DESC) AS rating,
	car AS unreliable_car
FROM (
	SELECT
		car,
		ROUND(AVG(cnt_orders), 1) AS avg_orders_by_car
	FROM orders_by_car
	GROUP BY car
);

--5. Самый "удачный" цвет для каждой модели авто

WITH cte AS (
	SELECT
		car,
		color,
		COUNT(order_id) cnt_orders
	FROM orders AS t1
	LEFT JOIN cars AS t2
		USING (car_id)
	GROUP BY car, color
)
SELECT car, color AS luckly_color
FROM (
	SELECT *,
		cnt_orders = MIN(cnt_orders) OVER (PARTITION BY car) AS flag
	FROM cte
	)
WHERE flag IS TRUE
