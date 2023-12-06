------------------------------------------------
-- SIMPLE QUERIES
------------------------------------------------

-- QUERY 1
SELECT * FROM students;

-- QUERY 2
SELECT * FROM majors;

-- QUERY 3
SELECT * FROM departments;

-- QUERY 4
SELECT * FROM teachers;

-- QUERY 5
SELECT * FROM books;

-- QUERY 6
SELECT * FROM authors;

-- QUERY 7
SELECT * FROM genres;

-- QUERY 8
SELECT * FROM book_taking_count;

-- QUERY 9
SELECT * FROM students_book_taking;

-- QUERY 10
SELECT * FROM students_book_returning;  

-- QUERY 11
SELECT name, surname, email FROM students WHERE admission_year = 2021;

-- QUERY 12
SELECT book_name FROM books WHERE author_id = 100000003;

-- QUERY 13
SELECT name, surname FROM teachers WHERE status = 'Instructor';

-- QUERY 14
SELECT genre_name, COUNT(*) AS book_count FROM books
JOIN genres ON books.genre_id = genres.genre_id
GROUP BY genre_name;

-- QUERY 15
SELECT department_name, CONCAT(teachers.name, ' ', teachers.surname) AS head_of_department
FROM departments 
JOIN teachers
ON departments.head_of_department = teachers.teacher_id;

-- QUERY 16 - Grouping by majors. 
SELECT major_name, COUNT(*) AS student_count
FROM students JOIN majors
ON students.major_id = majors.major_id
GROUP BY major_name;

-- QUERY 17 - Students book taking. 
SELECT students.name, students.surname, books.book_name, students_book_taking.taken_at
FROM students JOIN students_book_taking 
ON students.student_id = students_book_taking.student_id
JOIN books ON students_book_taking.book_id = books.book_id;

-- QUERY 18 - The top 5 students taking books. 
SELECT students.name, students.surname, 
COUNT(students_book_taking.book_id) AS books_borrowed 
FROM students 
JOIN students_book_taking 
ON students.student_id = students_book_taking.student_id
GROUP BY students.student_id 
ORDER BY books_borrowed DESC
LIMIT 5;

-- QUERY 19 - Students who DO NOT take any students.
SELECT students.name, students.surname FROM students
LEFT JOIN students_book_taking 
ON students.student_id = students_book_taking.student_id
WHERE students_book_taking.student_id IS NULL;

-- QUERY 20 - Teachers 
SELECT CONCAT(name, ' ', surname) AS teacher_name, status, department_name,
CASE 
    WHEN teacher_id = head_of_department THEN 'Head' ELSE 'Not Head' END AS department_head
FROM teachers
JOIN departments ON teachers.department_id = departments.department_id
ORDER BY teacher_name ASC;

-- QUERY 21 - Students
SELECT CONCAT(name, ' ', surname) AS student_name, admission_year, major_name, department_name
FROM students
JOIN majors ON students.major_id = majors.major_id
JOIN departments ON majors.department_id = departments.department_id 
ORDER BY student_name ASC;

