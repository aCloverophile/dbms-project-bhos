--------------------------------------------------------
-- INITIALIZATION OF THE DATABASE

CREATE DATABASE library_management_system;
USE library_management_system;
--------------------------------------------------------

--------------------------------------------------------
-- INITIALIZATION OF TABLES

CREATE TABLE students (
    student_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    admission_year YEAR NOT NULL,
    email VARCHAR(300) NOT NULL,
    major_id INT NOT NULL
);

CREATE TABLE majors (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    major_name VARCHAR(255) NOT NULL,
    department_id INT NOT NULL
) AUTO_INCREMENT = 1000000;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL,
    head_of_department INT NOT NULL
) AUTO_INCREMENT = 1000;

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    department_id INT NOT NULL, 
    email VARCHAR(255) NOT NULL, 
    status ENUM ('Professor', 'Associate Prof', 'Lecturer', 'Instructor', 'Teaching Assistant', 'Assistant Prof')
) AUTO_INCREMENT = 100000;

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(255) NOT NULL UNIQUE,
    publishment_year INT NOT NULL,
    author_id INT NOT NULL,
    genre_id INT NOT NULL, 
    count INT NOT NULL CHECK (count>=0)
) AUTO_INCREMENT = 10000000;

CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL
) AUTO_INCREMENT = 100000000;

CREATE TABLE genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255)
) AUTO_INCREMENT = 100;

CREATE TABLE book_taking_count (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id CHAR(36) NOT NULL UNIQUE,
    count INT CHECK (count >= 0 AND count <=5)
);

CREATE TABLE students_book_taking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id CHAR(36) NOT NULL, 
    book_id INT NOT NULL, 
    taken_at DATE NOT NULL
);

CREATE TABLE students_book_returning (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id CHAR(36) NOT NULL, 
    book_id INT NOT NULL, 
    returned_at DATE NOT NULL
);
--------------------------------------------------------


