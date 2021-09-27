/*5.13更新：删除system_user表  添加operation_info表 更新operation live_in take_care
5.14更新  删除operation表里的nurse id  添加operation nurse表  删除takecare表里的roomid和bedid operation info表中添加nurse_num
5.14更新2  删除live_in表里的bed_id 更新nurse表的dept_name外键
5.14更新3  给operation_nurse表增加主键
5.14更新4  撤回live in表中对bed_id的删除 更新live_in表中的主码为其全部属性

5.25更新   live_in表删除current_take_num
*/

/*5.25 去除所有外键以方便插入数据*/

/*7.12更新：
1.password字段长改为50  存储md5值
2.人员姓名长度改为12  即最多四个汉字
3.打开外键
*/
drop table department cascade CONSTRAINTS;
drop table room cascade CONSTRAINTS;
drop table system_administrator cascade CONSTRAINTS;
--drop table system_admin cascade CONSTRAINTS;
drop table medical_administrator cascade CONSTRAINTS;
drop table doctor cascade CONSTRAINTS;
drop table patient cascade CONSTRAINTS;
drop table nurse cascade CONSTRAINTS;
drop table bill cascade CONSTRAINTS;
drop table operation_section cascade CONSTRAINTS;
drop table operation_info cascade CONSTRAINTS;
drop table operation cascade CONSTRAINTS;
drop table take_care cascade CONSTRAINTS;
drop table live_in cascade CONSTRAINTS;

drop table medicine cascade CONSTRAINTS;
drop table prescribe cascade CONSTRAINTS;
drop table patient_state cascade CONSTRAINTS;
drop table registration cascade CONSTRAINTS;
drop table operation_report cascade CONSTRAINTS;


create table department
(
dept_name varchar(50),
primary key(dept_name)
);

drop table room;
create table room
(
room_id varchar(50),
room_capacity numeric(2,0),
room_available char(1),
primary key(room_id)
);

DROP TABLE system_administrator;

CREATE TABLE system_administrator (
  system_admin_id        VARCHAR(50),
  system_admin_name      VARCHAR(12),
  system_admin_password  VARCHAR(50),
  PRIMARY KEY ( system_admin_id )
);

DROP TABLE medical_administrator;

CREATE TABLE medical_administrator (
  medical_admin_id        VARCHAR(50),
  medical_admin_name      VARCHAR(12),
  medical_admin_password  VARCHAR(50),
  PRIMARY KEY ( medical_admin_id )
);
    
drop table doctor;
create table doctor
(
doctor_id varchar(50),
doctor_password varchar(50),
doctor_name varchar(12),
dept_name varchar(20),
phone_number varchar(20),
title varchar(20),
on_duty char(1),
on_job char(1),
primary key(doctor_id),
foreign key(dept_name) references department

);


drop table patient;
create table patient
(
patient_id varchar(50),
patient_name varchar(12),
phone_number varchar(20),
patient_address varchar(50),
admit_time timestamp,
discharge_time timestamp,
discharged char(1),
birthday timestamp,
sex varchar(10),
primary key(patient_id)
);

drop table nurse;
create table nurse
(
nurse_id varchar(50),
nurse_name varchar(12),
dept_name varchar(20),
phone_number varchar(20),
on_duty char(1),
on_job char(1),
nurse_password varchar(50),
primary key(nurse_id),
foreign key(dept_name) references department
);

drop table bill;
create table bill
(
bill_id varchar(50),
patient_id varchar(50),
total_cost numeric(10,2),
paid char(1),
primary key(bill_id),
foreign key(patient_id) references patient
);

    
drop table operation_section;
create table operation_section
	(
    sec_id		varchar(50),
    start_time  TIMESTAMP,
    end_time    TIMESTAMP,
	 primary key (sec_id)
	);

drop table operation_info;
create table operation_info
	(operation_name		varchar(120),
	 dept_name		varchar(50),
	 price		numeric(10,2),
     nurse_num numeric(2,0),
	 primary key (operation_name),
     foreign key (dept_name) references department
	);

drop table operation;
create table operation
	(doctor_id		varchar(50),
	 operation_id		varchar(50),
	 operation_name		varchar(120),
     sec_id varchar(50),
     patient_id varchar(50),
     operation_date   TIMESTAMP,
	 primary key (operation_id),
     foreign key (doctor_id) references doctor,
     foreign key (sec_id) references operation_section,
     foreign key (patient_id) references patient,
     foreign key (operation_name) references operation_info
	);

drop table operation_nurse;
create table operation_nurse
(
    nurse_id varchar(50),
    operation_id varchar(50),
	primary key(nurse_id,operation_id),
    foreign key (nurse_id) references nurse,
    foreign key (operation_id) references operation
);

drop table live_in;
create table live_in
	(patient_id		varchar(50),
	 admit_time  TIMESTAMP,
     discharge_time    TIMESTAMP,
     room_id    varchar(50),
     bed_id varchar(50),
	 primary key (patient_id,room_id,bed_id,admit_time,discharge_time),
     foreign key (patient_id) references patient,
     foreign key (room_id) references room
	);

drop table take_care;
create table take_care
	(nurse_id		varchar(50),
	 patient_id		varchar(50),
	 primary key (nurse_id,patient_id),
        foreign key (nurse_id) references nurse,
     foreign key (patient_id) references patient
     
	);





drop table medicine;
create table medicine
	(medicine_id    varchar(50),
     medicine_name    varchar(50),
	 price  numeric(10,2),
	 primary key (medicine_id)
	);


drop table prescribe;
create table prescribe /*开具处方*/
(
    prescribe_id varchar(50),
    medicine_id varchar(50),
    doctor_id varchar(50),
    patient_id varchar(50),
    dose varchar(50),
    unit varchar(4),
    prescribe_time timestamp,
    primary key (prescribe_id),
    foreign key (medicine_id) references medicine,
    foreign key (doctor_id) references doctor,
    foreign key (patient_id) references patient

);

drop table patient_state;
create table patient_state /*病情*/
(
    patient_id varchar(50),
    state_time timestamp,
    doctor_id varchar(50),
    illness_condition varchar(600),
    need_operation char(1),
    advice varchar(600),
    primary key (patient_id，state_time),
    foreign key (patient_id) references patient,
    foreign key (doctor_id) references doctor
);

DROP TABLE registration;

CREATE TABLE registration/*挂号*/ (
    doctor_id              VARCHAR(50),
    patient_id             VARCHAR(50),
    registration_time      TIMESTAMP,
    patient_serial_number  VARCHAR(20),
    dept_name              VARCHAR(20),
    PRIMARY KEY ( patient_id,doctor_id ),
    FOREIGN KEY ( doctor_id ) REFERENCES doctor,
    FOREIGN KEY ( patient_id ) REFERENCES patient,
    FOREIGN KEY ( dept_name )  REFERENCES department
);

DROP TABLE operation_report;

CREATE TABLE operation_report/*术后报告*/ (
    doctor_id     VARCHAR(50),
    operation_id  VARCHAR(50),
    conclusion    VARCHAR(1200),
    report_time   TIMESTAMP,
    PRIMARY KEY ( operation_id )  ,  
    FOREIGN KEY ( doctor_id ) REFERENCES doctor,
    FOREIGN KEY ( operation_id )  REFERENCES operation
);
