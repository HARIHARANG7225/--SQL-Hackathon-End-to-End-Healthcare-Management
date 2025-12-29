CREATE TABLE sql_hackothan.HEALTHCARE_SOURCE_TB (
              
    PATIENT_NAME VARCHAR(50) NOT NULL,
    gender VARCHAR(20) CHECK (gender IN ('Male','Female','Non-Binary')),
    date_of_birth DATE NOT NULL,
    street_address VARCHAR(100),
    city VARCHAR(50),
    state CHAR(2),                        
    zip_code VARCHAR(10),
    phone_number VARCHAR(25),
    doctor_first_name VARCHAR(50),
    doctor_last_name VARCHAR(50),
    doctor_specialization VARCHAR(100),     
    department_code VARCHAR(10),            
    department_name VARCHAR(50)            
);

select * from sql_hackothan.HEALTHCARE_SOURCE_TB;

------- DEPARTMENT TABLE -------

CREATE SEQUENCE sql_hackothan.DEP_SEQs START 1;

CREATE TABLE SQL_HACKOTHAN.DEP_TB (DEP_ID VARCHAR(20) DEFAULT 'DEP' ||
NEXTVAL('sql_hackothan.DEP_SEQs') PRIMARY KEY ,DEP_CODE VARCHAR(20)UNIQUE,DEPARTMENT_NAME
VARCHAR(20));

INSERT INTO SQL_HACKOTHAN.dep_tb (DEP_CODE,DEPARTMENT_NAME)
SELECT DISTINCT department_code, department_name
FROM sql_hackothan.healthcare_source_tb;

SELECT * FROM sql_hackothan.dep_tb;

----DOCTOR TABLE----
CREATE SEQUENCE sql_hackothan.DOC_SEQ start 1;

CREATE TABLE SQL_HACKOTHAN.DOC_TB(DOC_ID VARCHAR(30) DEFAULT
'DOC' || NEXTVAL('sql_hackothan.DOC_SEQ')PRIMARY KEY,
DOC_FIRST_NAME VARCHAR(40),
DOC_SECOND_NAME VARCHAR(40),
DEP_ID VARCHAR(40) REFERENCES
sql_hackothan.dep_tb(dep_id),
DOC_SPECIALITY VARCHAR (40));

INSERT INTO SQL_HACKOTHAN.DOC_TB (DOC_FIRST_NAME,
DOC_SECOND_NAME,DOC_SPECIALITY,DEP_ID)
SELECT 
A.doctor_first_name,A.doctor_last_name,A. doctor_specialization,
B.dep_id
FROM 
(SELECT DISTINCT DOCTOR_FIRST_NAME,DOCTOR_LAST_NAME,department_code,
doctor_specialization
FROM sql_hackothan.healthcare_source_tb )A JOIN sql_hackothan.dep_tb B
ON B.dep_code=A.department_code ORDER BY A.DOCTOR_FIRST_NAME ;

SELECT * FROM sql_hackothan.doc_tb;

---- LOCATION_TB---
CREATE SEQUENCE SQL_HACKOTHAN.LOC_SEQs;

CREATE TABLE SQL_HACKOTHAN.LOCATION_TB(locationt_id VARCHAR(40)
DEFAULT 'LOC-' || NEXTVAL('SQL_HACKOTHAN.LOC_SEQs') primary key, 
city VARCHAR(40),
state VARCHAR(40),
zipcode VARCHAR(40),
address TEXT
);


INSERT INTO sql_hackothan.location_tb
( city, state, zipcode, address)
SELECT city,state,zip_code,street_address
from sql_hackothan.healthcare_source_tb

SELECT * FROM sql_hackothan.location_tb

--- PATIENT_TABLE ----
CREATE SEQUENCE SQL_HACKOTHAN.PAT_SEQs;

CREATE TABLE SQL_HACKOTHAN.PATIENT_TB (PATIENT_ID VARCHAR(30) 
DEFAULT 'PAT-'||NEXTVAL('SQL_HACKOTHAN.PAT_SEQs') PRIMARY KEY,
NAME VARCHAR(30),
AGE INT ,
DATE_OF_BIRTH DATE ,
PHONE_NUMBER VARCHAR(30),LOCATION_ID VARCHAR(30)
REFERENCES sql_hackothan.location_tb(locationt_id),
Doc_id
VARCHAR(30) REFERENCES sql_hackothan.doc_tb(doc_id))
;




INSERT INTO sql_hackothan.patient_tb (NAME,AGE,
DATE_OF_BIRTH,
PHONE_NUMBER,LOCATION_ID,DOC_ID)
SELECT B.patient_name,
 extract(year from age(current_date ,date_of_birth
))as age ,B.date_of_birth,
B.phone_number,
A.locationt_id ,C.doc_id FROM sql_hackothan.location_tb AS A
JOIN sql_hackothan.healthcare_source_tb AS B ON B.city =
A.city
and B.state=A.state
and B.zip_code =A.zipcode
and B.street_address=A.address
JOIN sql_hackothan.doc_tb C ON B.doctor_first_name 
=C.doc_first_name and B.doctor_last_name = c.doc_second_name 
order by B.patient_name;

SELECT * FROM sql_hackothan.patient_tb;

-------------------scenario 01 :The hospital management wants to know which departments receive
--the highest number of patient visits,
--ranked by activity level-------------------------

---Find the total number of unique patients per
--department and rank departments by the number of visits---



select rank()over(order by visits desc) as Ranks,
dep.department_name,c.visits from(
select  dep_id,count(patient_id) as visits from(select 
A.patient_id,B.dep_id from sql_hackothan.patient_tb as A join
sql_hackothan.doc_tb B on A.doc_id=B.doc_id) as Tem group by
dep_id) as c join sql_hackothan.dep_tb as dep on dep.dep_id=c.dep_id;


------Find doctors who treat more patients than the average doctor in their department.
----Task:
--Compare each doctor’s patient count with the department’s average.


select temp_3.doctor,dep.department_name,temp_3.treatment_count from(
select 
doctor,dep_id,
treatment_count,
round(avg(treatment_count) over(partition by dep_id),2)as avg_per_dep,
(treatment_count)-(round(avg(treatment_count) over(partition by dep_id),2)) as diff
from (
select doctor,dep_id,count(doc_id) as treatment_count from(
select pa.patient_id,pa.doc_id,doc.doc_first_name 
||' '||doc.doc_second_name as doctor,doc.dep_id from
sql_hackothan.patient_tb as pa join sql_hackothan.doc_tb as doc
on pa.doc_id = doc.doc_id ) as temp group by doctor,dep_id order
by treatment_count desc) temp_2)temp_3 join 
sql_hackothan.dep_tb dep on temp_3.dep_id=dep.dep_id where diff > 0
order by doctor;



