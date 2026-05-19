create database insurance_analysis;

USE insurance_analysis;

-- customer table

CREATE TABLE customers (
 customer_id INT primary key,
 age INT,
 gender VARCHAR(10),
 region VARCHAR(50),
 annual_income Decimal(10,2),
 policy_type VARCHAR(50),
 premium_amount Decimal(10,2)
);

-- CREATE TABLE claims--

CREATE TABLE claims (
claim_id INT primary key,
customer_id INT,
claim_amount Decimal(10,2),
claim_date DATE,
claim_status VARCHAR(20),
fraud_flag Boolean,
foreign key (customer_id) references customers(customer_id)
);

-- inser customer dataset  --

INSERT INTO customers values
(1, 25, 'Male', 'Mumbai', 500000, 'Health', 12000),
(2, 40, 'Female', 'Delhi', 800000, 'Life', 25000),
(3, 35, 'Male', 'Bangalore', 600000, 'Auto', 15000),
(4, 50, 'Female', 'Chennai', 900000, 'Health', 30000),
(5, 28,  'Male', 'Pune', 450000, 'Auto', 10000),
(6, 45, 'Female', 'Mumbai', 1000000, 'Life', 35000),
(7, 33, 'Male', 'Delhi', 700000, 'Health', 20000),
(8, 60, 'Female', 'Bangalore', 1200000, 'Life', 40000),
(9, 38, 'Male', 'Chennai', 650000, 'Auto', 18000),
(10, 29, 'Female', 'Pune', 480000, 'Health', 11000),
(11, 55, 'Male', 'Mumbai', 1100000, 'Life', 38000),
(12, 31, 'Male', 'Delhi', 520000, 'Auto', 14000),
(13, 42, 'Male', 'Bangalore', 750000, 'Health', 22000),
(14, 36, 'Female', 'Chennai', 680000, 'Auto', 16000),
(15, 48, 'Male', 'Pune', 900000, 'Life', 32000),
(16, 27, 'Female', 'Mumbai', 400000, 'Health', 9000),
(17, 52, 'Male', 'Delhi', 980000, 'Life', 36000),
(18, 34, 'Female', 'Bangalore', 620000, 'Auto', 15500),
(19, 42, 'Male', 'Chennai', 720000, 'Health', 21000),
(20, 30, 'Female', 'Pune', 500000, 'Auto', 13000);

-- Insert claim dataset --

INSERT INTO CLAIMS VALUES
(101,1,15000,'2024-01-15','Approved',0),
(102,2,50000,'2024-02-10','Approved',1),
(103,3,8000,'2024-03-05','Rejected',0),
(104,4,60000,'2024-01-20','Approved',1),
(105,5,5000,'2024-04-12','Approved',0),
(106,6,70000,'2024-02-25','Approved',1),
(107,7,12000,'2024-03-18','Approved',0),
(108,8,90000,'2024-01-30','Approved',1),
(109,9,15000,'2024-04-01','Rejected',0),
(110,10,10000,'2024-03-22','Approved',0),
(111,2,30000,'2024-05-10','Approved',1),
(112,4,25000,'2024-05-15','Approved',0),
(113,6,40000,'2024-06-01','Approved',1),
(114,8,35000,'2024-06-10','Approved',1),
(115,11,85000,'2024-02-14', 'Approved',1),
(116,12,9000,'2024-03-09','Approved',0),
(117,13,22000,'2024-04-18','Approved',0),
(118,14,12000,'2024-05-22','Approved',0),
(119,15,45000,'2024-02-28','Approved',1),
(120,16,7000,'2024-03-30','Approved',0),
(121,17,95000,'2024-04-05','Approved',1),
(122,18,10000,'2024-05-12','Approved',0),
(123,19,18000,'2024-06-03','Approved',0),
(124,20,11000,'2024-06-15','Approved',0),
(125,1,8000,'2024-07-01','Approved',0),
(126,3,12000,'2024-07-10','Approved',0),
(127,5,6000,'2024-07-18','Rejected',0),
(128,7,15000,'2024-07-25','Approved',0),
(129,9,20000,'2024-08-02','Approved',1),
(130,11,50000,'2024-08-10','Approved',1),
(131,15,30000,'2024-08-18','Approved',0),
(132,17,40000,'2024-08-25','Approved',1),
(133,19,25000,'2024-09-01','Approved',0),
(134,20,9000,'2024-09-10','Approved',0),
(135,12,15000,'2024-09-15','Approved',0);

select * from claims;

select * from customers;

-- Total Revenue (Premium collected) --

SELECT sum(premium_amount) AS total_revenuecustomers
from customers;

select sum(premium_amount) as total_premium
from customers;

-- Total claim paid --

SELECT sum(claim_amount) as total_claim_paid
from claims
where claim_status = 'Approved';

-- Loss Ratio (Most Important KPI) --
Select 
 (SELECT sum(claim_amount) from claims where claim_status = 'Approved') /
 (SELECT sum(premium_amount) from customers)
  as loss_ratio;
  
  -- High Risk Customers(Claims>Premium)--
  
select c.customer_id,
       sum(cl.claim_amount) as total_claim,
       c.premium_amount
from customers c
join claims cl on c.customer_id = cl.customer_id
group by c.customer_id, c.premium_amount
having total_claim > c.premium_amount;

-- Region waise risk analysis --

select c.region,
       count(cl.claim_id) as total_claims,
       sum(cl.claim_amount) as total_claim_amount
from customers c
join claims cl on c.customer_id = cl.customer_id
group by c.region
order by total_claim_amount desc;

-- Window funcatioin --
select customer_id,
       claim_amount,
       rank() over (order by claim_amount desc) as claim_rank
from claims;

-- add index (performance optimize) --

create index idx_customer_id on claims(customer_id);

-- High risk customer --
Create view high_risk_customers as
select c.customer_id,
       sum(cl.claim_amount) as total_claim,
       c.premium_amount
from customers c
join claims cl on c.customer_id = cl.customer_id
group by c.customer_id, c.premium_amount
having total_claim > c.premium_amount;

-- find High risk customer --
select c.customer_id,
       sum(cl.claim_amount) as total_claim,
       c.premium_amount
from customers c
join claims cl on c.customer_id = cl.customer_id
where cl.claim_status = 'Approved'
group by c.customer_id, c.premium_amount
having total_claim > c.premium_amount;

-- Find Fraud Customers --

select customer_id,
       count(claim_id) as fraud_claims
from claims
where fraud_flag = 1
group by customer_id
having fraud_claims >=2;

