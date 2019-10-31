/* Первая часть:
В качестве ДЗ делам прогноз ТО на 05.2017. 
В качестве метода прогноза - считаем сколько денег тратят группы клиентов в день:
1. Группа часто покупающих (3 и более покупок) и которые последний раз покупали не так давно. 
Считаем сколько денег оформленного заказа приходится на 1 день. Умножаем на 30.
2. Группа часто покупающих, но которые не покупали уже значительное время. 
Так же можем сделать вывод, из такой группы за след месяц сколько купят и на какую сумму.
3. Отдельно разобрать пользователей с 1 и 2 покупками за все время, прогнозируем их.
4. В итоге у вас будет прогноз ТО и вы сможете его сравнить с фактом и оценить грубо разлет по данным.
Как источник данных используем данные по продажам за 2 года. */

USE new_1;

CREATE TABLE first_buy_3
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) >= 3 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 30;

CREATE TABLE second_buy_3
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) >= 3 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 30 AND
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 60;

CREATE TABLE third_buy_3
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) >= 3 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 60;

CREATE TABLE first_buy_1
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date),  DATE('2017-04-30')))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 1 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 30;

CREATE TABLE second_buy_1
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date),  DATE('2017-04-30')))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 1 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 60 AND
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 30;

CREATE TABLE third_buy_1
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date),  DATE('2017-04-30')))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 1 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 60;

CREATE TABLE first_buy_2
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 2 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 30;

CREATE TABLE second_buy_2
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 2 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) <= 60 AND
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 30;

CREATE TABLE third_buy_2
SELECT user_id, ceil((SUM(price)/timestampdiff(DAY, MIN(o_date), MAX(o_date)))*30) sum_per_month
FROM orders1
GROUP BY user_id
HAVING COUNT(id_o) = 2 AND 
TIMESTAMPDIFF(DAY, MAX(o_date), DATE('2017-04-30')) > 60;

SELECT * FROM(
SELECT '1 first month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM first_buy_1
UNION
SELECT '1 second month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM second_buy_1
UNION
SELECT '1 third and more month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM third_buy_1
UNION
SELECT '2 first month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM first_buy_2
UNION
SELECT '2 second month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM second_buy_2
UNION
SELECT '2 third and more month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM third_buy_2
UNION
SELECT '3+ first month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM first_buy_3
UNION
SELECT '3+ second month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM second_buy_3
UNION
SELECT '3+ third and more month' table_name, COUNT(*) QUANTITY, ceil(AVG(sum_per_month)) average_sum_per_month
  FROM third_buy_3
) t;

SELECT sum(s) Total_sum_May_2017
  FROM (
SELECT count(DISTINCT o.user_id), sum(o.price) s
  FROM orders1 o
  WHERE YEAR(o.o_date) = 2017 AND MONTH(o.o_date) = 5
  GROUP BY o.user_id) t;
 
