# Day 01. 기본 SQL 분석 환경 점검

## 1. 오늘의 목표

PostgreSQL에서 생성한 `sql_portfolio` 데이터베이스를 기준으로 현재 테이블 구조를 확인하고, 기본 조회와 데이터 건수 확인을 수행했다.

## 2. 현재 데이터베이스 구조

현재 사용 중인 데이터베이스는 `sql_portfolio`이며, 기본 스키마는 `public`이다.

현재 생성된 테이블은 다음과 같다.

| 스키마 | 테이블 |
|---|---|
| public | customers |
| public | orders |
| public | products |

## 3. 작성한 SQL 파일

- `02_projects/day01_basic_analysis.sql`

## 4. 학습한 SQL 개념

- `current_database()`
- `current_schema()`
- `information_schema.tables`
- `information_schema.columns`
- `SELECT`
- `COUNT(*)`
- `UNION ALL`
- `LIMIT`

## 5. 오류 해결 기록

```text
오류: relation "customers" does not exist
SQL state: 42P01

원인은 SQL 파일에서 SET search_path TO retail;을 사용했지만, 실제 테이블은 retail 스키마가 아니라 public 스키마에 생성되어 있었기 때문이다

SET search_path TO public; 로 수정했다.

# Day 01. Basic SQL Analysis

## 학습 목표

이번 학습의 목표는 PostgreSQL에서 SQL 기본 문법을 직접 실행하면서 데이터 분석의 기초 흐름을 익히는 것이다.

사용 테이블은 다음과 같다.

```text
retail.customers
retail.orders
retail.products
```

이번 프로젝트에서는 PostgreSQL의 기본 스키마인 `public`을 그대로 사용하지 않고, 실습 전용 스키마인 `retail`을 사용한다.

---

## 사전 점검 완료 내용

본격적인 SQL 학습에 들어가기 전에 다음 작업을 먼저 완료하였다.

```text
1. public 스키마에 있던 customers, orders, products 테이블을 retail 스키마로 이동하였다.
2. retail 스키마 안에 실습 테이블들이 정상적으로 존재하는지 확인하였다.
3. 각 테이블의 컬럼 구조를 확인하였다.
4. 각 테이블의 전체 행 개수를 확인하였다.
```

현재 기준 구조는 다음과 같다.

```text
sql_portfolio 데이터베이스
└─ retail 스키마
   ├─ customers
   ├─ orders
   └─ products
```

---

## pgAdmin과 VS Code 사용 방식

이번 프로젝트에서는 pgAdmin, VS Code, GitHub의 역할을 구분해서 사용한다.

```text
pgAdmin  = 쿼리를 실제 DB에서 실행하고 결과를 확인하는 공간
VS Code  = 정상 실행된 SQL 코드와 설명을 저장하는 공간
GitHub   = 학습 결과를 커밋하여 포트폴리오로 관리하는 공간
```

SQL 학습 초반에는 pgAdmin Query Tool에 이전 쿼리를 계속 남겨두지 않는 것이 좋다.

pgAdmin에서 선택 영역 없이 실행 버튼을 누르면 Query Tool 안에 있는 여러 쿼리가 함께 실행될 수 있다. 이 경우 내가 실행하려던 쿼리가 아닌 이전 쿼리까지 같이 실행되어 오류가 발생할 수 있다.

따라서 현재 단계에서는 다음 방식으로 진행한다.

```text
1. pgAdmin Query Tool의 기존 내용을 지운다.
2. 이번에 실행할 쿼리만 붙여넣는다.
3. 실행 후 결과를 확인한다.
4. 정상 실행된 쿼리만 VS Code의 .sql 파일에 저장한다.
5. 학습 설명은 notes 파일에 정리한다.
```

---

## search_path를 사용하는 이유

현재 테이블은 `retail` 스키마 안에 있다.

```text
retail.customers
retail.orders
retail.products
```

그런데 SQL에서 다음처럼 스키마명을 생략하면

```sql
FROM customers
```

PostgreSQL은 현재 `search_path`에 설정된 스키마에서 `customers` 테이블을 찾는다.

만약 `search_path`가 `public`으로 되어 있으면 PostgreSQL은 다음 위치에서 테이블을 찾으려고 한다.

```text
public.customers
```

하지만 현재 customers 테이블은 `public`이 아니라 `retail`에 있으므로 오류가 발생할 수 있다.

이를 방지하기 위해 쿼리 실행 전에 다음 문장을 사용한다.

```sql
SET search_path TO retail;
```

이 설정을 하면 이후부터는 아래 쿼리의 `customers`가

```sql
FROM customers
```

실제로는 다음과 같은 의미로 해석된다.

```sql
FROM retail.customers
```

즉, `SET search_path TO retail;`은 PostgreSQL에게 “앞으로 스키마명을 생략한 테이블은 retail 스키마에서 찾아라”라고 알려주는 설정이다.

---

## customers 테이블 컬럼 확인 결과

`customers` 테이블의 실제 컬럼은 다음과 같다.

```text
customer_id
customer_name
gender
age
city
signup_date
```

처음에는 가입일 컬럼명을 `join_date`로 예상했지만, 실제 테이블에는 `join_date` 컬럼이 없었다. 실제 가입일 컬럼명은 `signup_date`였다.

이때 발생한 오류는 다음과 같다.

```text
ERROR: "join_date" 이름의 칼럼은 없습니다
SQL state: 42703
```

이 오류는 테이블은 존재하지만, 조회하려는 컬럼명이 실제 테이블에 없을 때 발생한다.

정리하면 다음과 같다.

```text
42P01 = 테이블을 찾지 못한 오류
42703 = 컬럼을 찾지 못한 오류
```

---

## 1. SELECT 기본 조회

### 실행 쿼리

```sql
SET search_path TO retail;

SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    signup_date
FROM customers
ORDER BY customer_id;
```

---

## 실행 목적

이 쿼리는 `customers` 테이블에서 고객 기본 정보를 조회하는 가장 기본적인 SQL문이다.

분석을 시작할 때는 전체 컬럼을 무작정 조회하기보다, 분석에 필요한 컬럼을 직접 선택하는 것이 좋다.

이번 쿼리에서는 다음 컬럼을 조회하였다.

```text
customer_id     고객 고유 번호
customer_name   고객 이름
gender          성별
age             나이
city            거주 도시
signup_date     가입일
```

---

## 쿼리 설명

### SET search_path TO retail;

```sql
SET search_path TO retail;
```

현재 SQL 세션의 기본 스키마를 `retail`로 설정한다.

이 설정을 해두면 `customers`라고만 작성해도 PostgreSQL은 `retail.customers` 테이블을 조회한다.

---

### SELECT

```sql
SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    signup_date
```

`SELECT`는 테이블에서 어떤 컬럼을 조회할지 지정하는 문법이다.

여기서는 `customers` 테이블의 고객 기본 정보 컬럼을 직접 선택하였다.

---

### FROM customers

```sql
FROM customers
```

`FROM`은 데이터를 가져올 테이블을 지정하는 문법이다.

현재 `search_path`가 `retail`로 설정되어 있기 때문에 `customers`는 `retail.customers`를 의미한다.

---

### ORDER BY customer_id

```sql
ORDER BY customer_id;
```

`ORDER BY`는 조회 결과를 정렬하는 문법이다.

여기서는 고객 ID 기준으로 오름차순 정렬하였다.

PostgreSQL에서 `ORDER BY customer_id`는 기본적으로 다음과 같은 의미다.

```sql
ORDER BY customer_id ASC;
```

`ASC`는 오름차순이고, `DESC`는 내림차순이다.

---

## SELECT *와 컬럼 직접 지정의 차이

SQL을 처음 배울 때는 다음처럼 전체 컬럼을 조회할 수 있다.

```sql
SELECT *
FROM customers;
```

`*`는 모든 컬럼을 조회한다는 뜻이다.

하지만 실무와 포트폴리오에서는 필요한 컬럼을 직접 지정하는 것이 좋다.

```sql
SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    signup_date
FROM customers;
```

이 방식의 장점은 다음과 같다.

```text
1. 쿼리의 목적이 명확하다.
2. 불필요한 컬럼을 조회하지 않는다.
3. 데이터가 많을 때 성능상 유리하다.
4. 포트폴리오에서 분석 의도가 잘 드러난다.
```

---

## SQLD 시험 대비 포인트

SQL문의 기본 작성 순서는 다음과 같다.

```sql
SELECT 컬럼명
FROM 테이블명
WHERE 조건
GROUP BY 그룹기준
HAVING 그룹조건
ORDER BY 정렬기준;
```

하지만 논리적 실행 순서는 작성 순서와 다르다.

```text
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
```

즉, SQL은 먼저 `FROM`에서 테이블을 찾고, 그다음 `WHERE` 조건으로 행을 필터링하고, `GROUP BY`로 그룹화한 뒤, `SELECT`에서 조회할 컬럼을 결정하고, 마지막에 `ORDER BY`로 정렬한다.

이번 쿼리는 그중 가장 기본 구조인 다음 형태를 연습한 것이다.

```sql
SELECT 컬럼명
FROM 테이블명
ORDER BY 정렬기준;
```

---

## 이번 단계 정리

이번 단계에서는 `customers` 테이블에서 고객 기본 정보를 조회하였다.

핵심은 다음과 같다.

```text
1. pgAdmin은 쿼리 실행용으로 사용한다.
2. VS Code는 정상 실행된 쿼리를 저장하는 공간으로  사용한다.
3. retail 스키마를 기준으로 분석한다.
4. SET search_path TO retail;을 사용하여 기본 스키마를 지정한다.
5. SELECT는 조회할 컬럼을 선택하는 문법이다.
6. ORDER BY는 조회 결과를 정렬하는 문법이다.
7. 실제 컬럼명은 information_schema.columns로 확인할 수 있다.
```
## 1. SELECT 기본 조회

customers 테이블에서 고객 ID, 고객명, 성별, 나이, 도시, 가입일 정보를 조회하였다.

이번 쿼리는 SQL의 가장 기본 구조인 `SELECT 컬럼명 FROM 테이블명`을 연습하기 위한 쿼리다.  
분석을 시작할 때는 전체 컬럼을 무작정 조회하기보다, 분석 목적에 맞는 컬럼을 직접 선택하는 것이 좋다.

`SET search_path TO retail;`을 사용하여 현재 세션의 기본 스키마를 retail로 설정하였다.  
이를 통해 `customers`라고만 작성해도 PostgreSQL은 `retail.customers` 테이블을 조회한다.

`ORDER BY customer_id`를 사용하여 고객 ID 기준으로 결과를 오름차순 정렬하였다.  
정렬을 적용하면 데이터의 흐름을 더 쉽게 확인할 수 있다.

## 2. WHERE 조건 필터링

customers 테이블에서 나이가 30세 이상인 고객만 조회하였다.

`WHERE`는 테이블의 행 중에서 조건을 만족하는 데이터만 필터링할 때 사용한다.  
이번 쿼리에서는 `WHERE age >= 30` 조건을 사용하여 30세 이상 고객만 결과에 포함하였다.

`>=`는 “크거나 같다”는 의미의 비교 연산자이다.  
따라서 `age >= 30`은 나이가 30 이상인 고객을 의미한다.

조회 결과는 `ORDER BY age DESC`를 사용하여 나이가 많은 고객부터 정렬하였다.  
`DESC`는 내림차순 정렬을 의미한다.

이번 단계의 핵심은 `WHERE`가 원본 데이터에서 조건에 맞는 행만 남기는 문법이라는 점이다.

## 3. ORDER BY 정렬

customers 테이블의 고객 데이터를 도시 기준으로 오름차순 정렬하고, 같은 도시 안에서는 나이가 많은 고객부터 조회하였다.

`ORDER BY`는 조회 결과를 특정 컬럼 기준으로 정렬할 때 사용하는 문법이다.

이번 쿼리에서는 다음 두 가지 정렬 기준을 사용하였다.

## 4. COUNT 집계

customers 테이블의 전체 고객 수를 조회하였다.

`COUNT(*)`는 테이블의 전체 행 개수를 세는 집계 함수이다.  
고객 한 명이 한 행으로 저장되어 있다면, `COUNT(*)` 결과는 전체 고객 수를 의미한다.

이번 쿼리에서는 다음과 같이 작성하였다.


## 5. GROUP BY 그룹 집계

customers 테이블에서 도시별 고객 수를 집계하였다.

`GROUP BY`는 같은 값을 가진 행들을 하나의 그룹으로 묶을 때 사용하는 문법이다.  
이번 쿼리에서는 `city`를 기준으로 고객을 그룹화하였다.

```sql
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city ASC;

## 6. WHERE + GROUP BY 조건 집계

customers 테이블에서 30세 이상 고객만 필터링한 뒤, 도시별 고객 수를 집계하였다.

이번 쿼리의 분석 질문은 다음과 같다.

```text
30세 이상 고객은 도시별로 몇 명씩 있는가?

## Day 01 마무리 요약

이번 Day 01 학습에서는 PostgreSQL의 기본 SQL 문법을 활용하여 `retail.customers` 테이블을 분석하였다.

사전 점검 단계에서는 `public` 스키마에 있던 실습 테이블을 `retail` 스키마로 이동하고, `customers`, `orders`, `products` 테이블의 존재 여부와 컬럼 구조, 전체 행 개수를 확인하였다. 이후 본격적인 SQL 학습에서는 `customers` 테이블을 기준으로 기본 조회, 조건 필터링, 정렬, 집계, 그룹 집계를 순서대로 연습하였다.

---

### 1. SELECT 기본 조회

`SELECT`를 사용하여 `customers` 테이블에서 필요한 컬럼만 조회하였다.

조회한 컬럼은 다음과 같다.

```text
customer_id
customer_name
gender
age
city
signup_date
```

분석을 시작할 때 `SELECT *`로 전체 컬럼을 조회할 수도 있지만, 포트폴리오와 실무에서는 필요한 컬럼을 직접 지정하는 방식이 더 적합하다. 필요한 컬럼을 명확히 작성하면 쿼리의 목적이 잘 드러나고, 불필요한 데이터 조회를 줄일 수 있다.

---

### 2. WHERE 조건 필터링

`WHERE age >= 30` 조건을 사용하여 30세 이상 고객만 조회하였다.

`WHERE`는 원본 테이블의 행 중에서 조건을 만족하는 데이터만 남기는 문법이다. 실무에서는 전체 데이터를 그대로 보는 것보다 특정 조건에 맞는 고객, 주문, 상품 데이터를 추출하는 경우가 많기 때문에 매우 중요한 문법이다.

예를 들어 이번 학습에서는 전체 고객 중에서 나이가 30세 이상인 고객만 필터링하였다.

---

### 3. ORDER BY 정렬

`ORDER BY`를 사용하여 조회 결과를 정렬하였다.

이번 학습에서는 다음과 같은 다중 정렬을 사용하였다.

```sql
ORDER BY city ASC, age DESC;
```

이 정렬은 먼저 도시명을 오름차순으로 정렬하고, 같은 도시 안에서는 나이가 많은 고객부터 보여준다. 여러 컬럼을 기준으로 정렬할 때는 왼쪽에 있는 컬럼부터 우선순위가 적용된다.

---

### 4. COUNT 집계

`COUNT(*)`를 사용하여 `customers` 테이블의 전체 고객 수를 확인하였다.

실행 결과 현재 `customers` 테이블에는 총 4명의 고객 데이터가 저장되어 있음을 확인하였다.

```sql
SELECT
    COUNT(*) AS total_customers
FROM customers;
```

`COUNT(*)`는 NULL 여부와 관계없이 전체 행 개수를 세는 집계 함수이다. 반면 `COUNT(컬럼명)`은 해당 컬럼 값이 NULL이 아닌 행만 센다. 따라서 전체 데이터 건수를 확인할 때는 보통 `COUNT(*)`를 사용한다.

---

### 5. GROUP BY 그룹 집계

`GROUP BY city`를 사용하여 도시별 고객 수를 집계하였다.

```sql
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city ASC;
```

`GROUP BY`는 같은 값을 가진 행들을 하나의 그룹으로 묶는 문법이다. 이번 쿼리에서는 `city` 값을 기준으로 고객을 그룹화하고, 각 도시별 고객 수를 계산하였다.

`GROUP BY`에서 중요한 규칙은 `SELECT`절에 있는 일반 컬럼은 반드시 `GROUP BY`절에 포함되어야 한다는 점이다. 이번 쿼리에서는 일반 컬럼인 `city`가 `SELECT`절에 있으므로 `GROUP BY city`가 필요하다.

---

### 6. WHERE + GROUP BY 조건 집계

마지막으로 `WHERE`와 `GROUP BY`를 함께 사용하여 30세 이상 고객의 도시별 분포를 분석하였다.

```sql
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
WHERE age >= 30
GROUP BY city
ORDER BY customer_count DESC, city ASC;
```

이 쿼리는 전체 고객을 바로 그룹화하는 것이 아니라, 먼저 `WHERE age >= 30` 조건으로 30세 이상 고객만 필터링한 뒤, 남은 고객을 도시별로 그룹화한다.

논리적 실행 순서는 다음과 같다.

```text
FROM
WHERE
GROUP BY
SELECT
ORDER BY
```

이 흐름을 이해하는 것은 SQLD 시험에서도 중요하고, 실무 분석에서도 매우 중요하다.

---

### Day 01 핵심 정리

Day 01에서 학습한 핵심 개념은 다음과 같다.

```text
SELECT   : 조회할 컬럼을 선택한다.
FROM     : 데이터를 가져올 테이블을 지정한다.
WHERE    : 조건에 맞는 행만 필터링한다.
ORDER BY : 조회 결과를 정렬한다.
COUNT    : 행 개수를 집계한다.
GROUP BY : 같은 값을 가진 행들을 그룹화한다.
```

이번 학습을 통해 단순 조회에서 시작해 조건 필터링, 정렬, 전체 집계, 그룹 집계까지 SQL 기본 분석 흐름을 익혔다.
특히 `customers` 테이블을 활용하여 전체 고객 수, 조건에 맞는 고객, 도시별 고객 수를 직접 조회하며 데이터 분석의 기본 구조를 연습하였다.

Day 01은 SQL 기본 문법을 실습 데이터에 적용해보는 단계였으며, 이후 Day 02에서는 `orders`, `products` 테이블까지 함께 활용하여 주문 데이터와 상품 데이터를 분석하는 방향으로 확장할 수 있다.
