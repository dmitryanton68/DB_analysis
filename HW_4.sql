USE new_1;

-- 1. На основе данных по продажам за 16 и 17 год на основе когортного анализа по дате первой покупки спрогнозировать 
-- товарооборот января 2018 года (с выводом кэфов поведения когротны по порядковому номеру месяца)

CREATE TABLE first_purchase
SELECT DATE_FORMAT(MIN(o_date), "%y-%m") first_purchase, COUNT(user_id) quantity_of_users, ceil(SUM(price)) income
  FROM orders1
  GROUP BY YEAR(o_date), MONTH(o_date);

CREATE TABLE cohort
SELECT user_id, DATE_FORMAT(MIN(o_date), "%y-%m") cohorts
  FROM orders1
  WHERE YEAR(o_date) = 2017
  GROUP BY user_id;

CREATE TABLE cohort_1
SELECT user_id, o_date, price
FROM orders1
WHERE YEAR(o_date) = 2017;

/*CREATE TABLE cohort_analisys
SELECT c.cohorts, DATE_FORMAT(o.o_date, "%y-%m") month_purchase, ceil(SUM(o.price)) income 
FROM cohort_1 o
  JOIN cohort c
  ON o.user_id = c.user_id
  GROUP BY c.cohorts, month_purchase;*/

CREATE TABLE cohort_analisys
SELECT c.cohorts, DATE_FORMAT(o.o_date, "%y-%m") month_purchase, ceil(SUM(o.price)) income 
FROM orders1 o
  JOIN cohort c
  ON o.user_id = c.user_id;


-- 2. Продумать, как можно сделать объединение пользователей (мердж) по совпадению контактных данных. 
-- Кусок данных в материалах к уроку. (на занятии обсуждали)

CREATE TABLE t
  SELECT user_id, phone
  FROM users
  UNION
  SELECT user_id, email
  FROM users;

SELECT t.user_id, MIN(t2.user_id)
  FROM t
  JOIN t AS t2
  ON t.phone = t2.phone
  GROUP BY t.user_id;
