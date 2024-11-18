# Проектирование и нормализация базы данных

## Описание:
Предоставлены данные по работе сети автосервисов за последние 5 лет. В процессе работы сервисы накопили данные о клиентах, автомобилях, услугах и заказах, однако из-за отсутствия четкой структуры данных возникли проблемы с дублированием информации, сложностью в анализе и поддержке базы данных.

**Требуется привести базу данных (БД) к 3NF, построить связи между таблицами и выполнить ряд задач.**

## Выполненные задачи
1. Разведочный анализ данных БД: проверка кол-ва уникальных и NULL значений.
2. Проведено заполнение NULL значений дубликатами неповторяющихся данных (где возможно) и проведена дедупликация записей в БД.
3. Оставшиеся NULL заполнены значениями по умолчанию ('Неизвестно').
4. БД приведена к 1NF: удалены дубликаты, в каждой ячейке простые и атомарные значения.
5. БД приведена к 2NF: отсутствуют частичные зависимости от составных ключей.
6. БД приведена к 3NF: исключены транзитивные зависимости путем декомпозиции БД на следующие таблицы (`services`, `workers`, `clients`, `cars`, `cards`, `orders`).
7. В каждой таблице создан автоинкрементный столбец (PRIMERY KEY - id) уникально идентифицирующий записи в таблице.
8. Построены связи между таблицами.
9. Проведена индексация в каждой таблице хотя бы по одному столбцу (структура INDEX- BTREE или бинарное дерево).
10. При использовании нормализованной БД выполнен ряд задач:
    - Увеличена зарпалата трем самым результативным механикам на 10%;
    - Создан рейтинг самых надежных и ненадежных авто (по количеству заказов);
    - Определен самый 'удачный' цвет для каждой марки машины (меньше всего заказов);
    - Создана таблица скидок (`discounts`) для самых частых клиентов: 10% скидка для топ 10 клиентов, 5% скидка для топ 100 клиентов по числу заказов;
    - Сделано представление для директора (`last_month_results`): филиал, количество заказов за последний месяц, заработанная сумма (revenue), заработанная сумма за вычетом зарплат (profit);

Полученная схема БД:

![gjgv](https://github.com/PonomarenkoDA/images/blob/main/database.PNG?raw=true)

