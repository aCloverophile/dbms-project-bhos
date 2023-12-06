-- LIST ALL FUNCTIONS
SELECT routine_name
FROM information_schema.routines
WHERE routine_type = 'FUNCTION' AND routine_schema = 'library_management_system';

-- FUNCTION 1
DELIMITER //
CREATE FUNCTION GetStudentFullName(student_id CHAR(36))
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(255);
    SELECT CONCAT(name, ' ', surname) INTO full_name
    FROM students
    WHERE students.student_id = student_id;
    RETURN full_name;
END //
DELIMITER ;

-- FUNCTION 2
DELIMITER //
CREATE FUNCTION GetBookAuthor(book_id INT)
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE author_name VARCHAR(255);
    SELECT authors.author_name INTO author_name
    FROM books
    JOIN authors ON books.author_id = authors.author_id
    WHERE books.book_id = book_id;
    RETURN author_name;
END //
DELIMITER ;

-- FUNCTION 3
DELIMITER //
CREATE FUNCTION GetDepartmentHead(department_id INT)
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE head_name VARCHAR(255);
    SELECT CONCAT(teachers.name,' ',teachers.surname) INTO head_name
    FROM departments
    JOIN teachers ON departments.head_of_department = teachers.teacher_id
    WHERE departments.department_id = department_id;
    RETURN head_name;
END //
DELIMITER ;



