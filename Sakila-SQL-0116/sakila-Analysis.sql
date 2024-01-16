-- 결과 이미지 image.md 저장

-- 데이터 조회 및 필터링
-- 특정 배우가 출연한 영화 목록 조회
-- 문제: 배우 'GUINESS PENELOPE'가 출연한 모든 영화의 제목을 조회하시오.
-- actor 테이블에서 'GUINESS PENELOPE'의 actor_id를 찾습니다.
-- film_actor 테이블과 film 테이블을 조인하여 해당 배우의 film_id를 찾고, 이를 통해 영화 제목을 가져옵니다.

 SELECT f.title
 FROM film f
 JOIN film_actor fa ON f.film_id = fa.film_id  
 JOIN actor a ON fa.actor_id = a.actor_id
 WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS';

-- 모든 카테고리와 해당 카테고리의 영화 수 조회
-- 문제: 각 카테고리별로 몇 개의 영화가 있는지 조회하시오.
-- category 테이블과 film_category 테이블을 조인합니다.
-- 집계 함수(COUNT)를 사용하여 각 category_id별 영화 수를 세어 집계합니다.

 SELECT c.name, COUNT(fc.film_id) as number_of_films
 FROM category c 
 JOIN film_category fc ON c.category_id = fc.category_id
 GROUP BY c.name; # 카테고리 이름이 같은걸 합쳐라

-- 특정 고객의 대여 기록 조회
-- 문제: 고객 ID가 5인 고객의 모든 대여 기록을 조회하시오.
-- 힌트:
-- customer 테이블에서 customer_id가 5인 고객을 찾습니다.
-- rental 테이블과 조인하여 해당 고객의 대여 기록을 조회합니다.

SELECT r.rental_date, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = 5;

-- 가장 최근에 추가된 10개의 영화 조회
-- 문제: 가장 최근에 데이터베이스에 추가된 10개의 영화 제목을 조회하시오.
-- 힌트:
-- film 테이블에서 release_year 및 title을 선택합니다.
-- 결과를 최신 순으로 정렬하고 상위 10개를 선택합니다.

SELECT title
FROM film
ORDER BY release_year DESC   -- descending order     ASC ascending order
LIMIT 10;

-- 특정 영화에 출연한 배우 목록 조회
-- 'ACADEMY DINOSAUR' 영화에 출연한 모든 배우의 이름을 조회하시오.  
-- `film`테이블에서 'ACADEMY DINOSAUR'의`film_id`를 찾습니다.
-- `film_actor`테이블과 `actor`테이블을 조인하여 해당 영화에 출연한 배우들의 이름을 조회합니다.
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 특정 영화를 대여한 고객 목록 조회
-- 문제: 'ACADEMY DINOSAUR' 영화를 대여한 모든 고객의 이름을 조회하시오.
-- film과 inventory 테이블을 조인하여 'ACADEMY DINOSAUR'의 inventory_id를 찾습니다.
-- rental과 customer 테이블을 조인하여 해당 inventory_id에 해당하는 대여 기록을 찾고 고객의 이름을 조회합니다.

SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 모든 고객과 그들이 가장 최근에 대여한 영화 조회
-- 문제: 각 고객별로 가장 최근에 대여한 영화의 제목을 조회하시오.
-- rental, inventory, film, customer 테이블을 조인합니다.
-- 각 고객별(customer.customer_id)로 가장 최근의 대여 날짜(rental.rental_date)를 기준으로 영화 제목을 조회합니다.

SELECT c.customer_id, c.first_name, c.last_name, MAX(r.rental_date) as last_rental_date, f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name, f.title;

-- 각 영화별 평균 대여 기간 조회
-- 문제: 각 영화별 평균 대여 기간을 일 단위로 계산하시오.
-- rental, inventory, film 테이블을 조인합니다.
-- rental 테이블에서 rental_date와 return_date를 사용하여 각 영화별 평균 대여 기간을 계산합니다.

SELECT f.title, AVG(DATEDIFF(r.return_date, r.rental_date)) as avg_rental_period
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title;

-- 집계 및 그룹화
-- 가장 많이 대여된 영화 조회
-- 문제: 가장 많이 대여된 영화의 제목과 대여 횟수를 조회하시오.
-- rental과 inventory 테이블을 조인하여 각 영화의 대여 횟수를 계산합니다.
-- film 테이블과 조인하여 영화 제목을 가져옵니다.
-- 대여 횟수를 기준으로 정렬하여 가장 많이 대여된 영화를 찾습니다.

SELECT f.title, COUNT(r.rental_id) as rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;

-- 각 카테고리별 평균 대여 요금 조회
-- 문제: 각 카테고리별 평균 대여 요금을 계산하시오.
-- 힌트:
-- category, film_category, film 테이블을 조인하여 각 카테고리별 영화 정보를 가져옵니다.
-- film.rental_rate를 사용하여 카테고리별 평균 대여 요금을 계산합니다.

SELECT c.name, AVG(f.rental_rate) as average_rental_rate
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name;

-- 월별 총 매출 조회
-- 문제: 각 월별로 총 매출액을 계산하시오.
-- payment 테이블에서 amount와 payment_date를 사용합니다.
-- 월별로 그룹화하여 총 매출액을 집계합니다.

SELECT YEAR(p.payment_date) as year, MONTH(p.payment_date) as month, SUM(p.amount) as total_sales
FROM payment p
GROUP BY YEAR(p.payment_date), MONTH(p.payment_date);

-- 각 배우별 출연한 영화 수 조회
-- 문제: 각 배우별로 출연한 영화 수를 계산하시오.
-- actor와 film_actor 테이블을 조인합니다.
-- 각 배우별(actor_id)로 film_id의 수를 세어 집계합니다.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) as number_of_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

-- 서브쿼리 및 고급 기능
-- 가장 수익이 많은 영화 조회
-- 문제: 가장 많은 수익을 낸 영화의 제목과 수익을 조회하시오.
-- payment, rental, inventory, film 테이블을 조인합니다.
-- 각 영화별로 총 수익을 계산하고, 가장 높은 수익을 낸 영화를 찾습니다.

SELECT f.title, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 1;


-- 평균 대여 요금보다 높은 요금의 영화 조회
-- 문제: 평균 대여 요금보다 높은 요금의 영화 제목과 요금을 조회하시오.
-- 힌트:
-- film 테이블에서 평균 대여 요금(rental_rate)을 계산합니다.
-- 평균보다 높은 대여 요금을 가진 영화를 찾습니다.

SELECT f.title, f.rental_rate
FROM film f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film);

-- 가장 활동적인 고객 조회
-- 문제: 가장 많은 영화를 대여한 고객의 이름과 대여 횟수를 조회하시오.
-- rental과 customer 테이블을 조인합니다.
-- 각 고객별로 대여 횟수를 계산하고 가장 많이 대여한 고객을 찾습니다.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY rental_count DESC
LIMIT 1;

-- 특정 배우가 출연한 영화 중 가장 인기 있는 영화 조회
-- 문제: 배우 'PENELOPE GUINESS'가 출연한 영화 중 가장 많이 대여된 영화의 제목과 대여 횟수를 조회하시오.
-- 힌트:
-- actor, film_actor, inventory, rental, film 테이블을 조인합니다.
-- 해당 배우가 출연한 영화들의 대여 횟수를 계산하고 가장 많이 대여된 영화를 찾습니다.

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS'
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;

### 데이터 수정 및 관리
-- 새로운 영화 추가
-- 문제: 'film' 테이블에 'New Adventure Movie'라는 새로운 영화를 추가하시오.
-- INSERT INTO 구문을 사용하여 film 테이블에 새로운 레코드를 추가합니다.
-- 모든 필요한 필드에 대한 값을 명시합니다.

INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features)
VALUES ('New Adventure Movie', 'A thrilling adventure of the unknown', 2023, 1, 3, 4.99, 120, 19.99, 'PG', 'Trailers,Commentaries');


-- 고객 정보 업데이트
-- 문제: 고객 ID가 5인 고객의 주소를 '123 New Address, New City'로 변경하시오.
-- UPDATE 구문을 사용하여 customer 테이블의 레코드를 업데이트합니다.
-- customer_id를 사용하여 특정 고객을 식별하고, address_id를 찾은 다음 address 테이블에서 해당 주소를 업데이트합니다.

UPDATE customer
SET address_id = (SELECT address_id FROM address WHERE address = '123 New Address, New City')
WHERE customer_id = 5;
select * from customer;

-- 영화 대여 상태 변경
-- 문제: 대여 ID가 200인 대여 기록의 상태를 'returned'로 변경하시오.
-- UPDATE 구문을 사용하여 rental 테이블의 레코드를 업데이트합니다.
-- rental_id를 사용하여 특정 대여 기록을 식별하고, return_date를 현재 날짜/시간으로 설정합니다.

UPDATE rental
SET return_date = NOW()
WHERE rental_id = 200;

-- 배우 정보 삭제
-- 문제: 배우 ID가 10인 배우의 정보를 삭제하시오.
-- DELETE FROM 구문을 사용하여 actor 테이블에서 특정 레코드를 삭제합니다.
-- 삭제하기 전에 film_actor 테이블에서 해당 배우와 관련된 모든 레코드를 삭제하거나 확인합니다.

DELETE FROM actor
WHERE actor_id = 10;

