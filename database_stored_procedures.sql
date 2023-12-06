-- LIST ALL PROCEDURES
SELECT routine_name
FROM information_schema.routines
WHERE routine_type = 'PROCEDURE'
AND routine_schema = 'library_management_system';


-- PROCEDURE 1: Student takes a book. 
DELIMITER //

CREATE PROCEDURE TakeBook(
    IN p_student_id CHAR(36),
    IN p_book_id INT
)
BEGIN
    DECLARE book_count INT;
    SELECT count INTO book_count FROM book_taking_count WHERE student_id = p_student_id;
    IF book_count < 5 THEN
        IF EXISTS (SELECT 1 FROM books WHERE book_id = p_book_id AND count > 0) THEN
            IF NOT EXISTS (SELECT 1 FROM students_book_taking WHERE student_id = p_student_id AND book_id = p_book_id) THEN
                UPDATE books SET count = count - 1 WHERE book_id = p_book_id;
                INSERT INTO students_book_taking (student_id, book_id, taken_at) VALUES (p_student_id, p_book_id, CURRENT_DATE);
                UPDATE book_taking_count SET count = count + 1 WHERE student_id = p_student_id;
            ELSE
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'The student has already taken this book. Each student can take only one copy of a book at a time.';
            END IF;
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Sorry, this book currently does not exist in the library. Please wait for other students to return';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot take more than 5 books';
    END IF;
END //
DELIMITER ;


-- PROCEDURE 2: Student returns a book. 
DELIMITER //
CREATE PROCEDURE ReturnBook(
    IN p_student_id CHAR(36),
    IN p_book_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM students_book_taking WHERE student_id = p_student_id AND book_id = p_book_id) THEN
        UPDATE books SET count = count + 1 WHERE book_id = p_book_id;
        INSERT INTO students_book_returning (student_id, book_id, returned_at) VALUES (p_student_id, p_book_id, CURRENT_DATE);
        DELETE FROM students_book_taking WHERE student_id = p_student_id AND book_id = p_book_id;
        UPDATE book_taking_count SET count = count - 1 WHERE student_id = p_student_id;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The student has not taken this book';
    END IF;
END //
DELIMITER ;


-- CHECK PROCEDURE 1 & 2
CALL TakeBook('7ae436c0-93b6-11ee-8173-005056c00001', 10000024);
CALL TakeBook('7ae463c0-93b6-11ee-8173-005056c00001', '10000027');
CALL ReturnBook('7ae436c0-93b6-11ee-8173-005056c00001', 10000024);


-- PROCEDURE 3: A new student is inserted to the database. 
DELIMITER //
CREATE PROCEDURE InsertStudent(
    IN p_name VARCHAR(255),
    IN p_surname VARCHAR(255),
    IN p_admission_year YEAR,
    IN p_email VARCHAR(300),
    IN p_major_id INT
)
BEGIN
    DECLARE current_year YEAR;
    SET current_year = YEAR(NOW());
    IF NOT EXISTS (SELECT 1 FROM majors WHERE major_id = p_major_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid major_id. Please provide a valid major_id.';
    ELSE
        INSERT INTO students (name, surname, admission_year, email, major_id)
        VALUES (p_name, p_surname, p_admission_year, p_email, p_major_id);
    END IF;
END //
DELIMITER ;

-- CHECK PROCEDURE 3
CALL InsertStudent('Tomris', 'Huseynova', 2027, 'tomris.huseynova@bhos.edu.az', 1000005); -- FAIL
CALL InsertStudent('Tomris', 'Huseynova', 2020, 'tomris.huseynova@bhos.edu.az', 1000005); -- SUCCESS


-- PROCEDURE 4: A new book is inserted into the database. 
DELIMITER //
CREATE PROCEDURE InsertBook(
    IN p_book_name VARCHAR(255),
    IN p_publishment_year INT,
    IN p_author_id INT,
    IN p_genre_id INT,
    IN p_count INT
)
BEGIN
    INSERT INTO books (book_name, publishment_year, author_id, genre_id, count)
    VALUES (p_book_name, p_publishment_year, p_author_id, p_genre_id, p_count);
END //
DELIMITER ;

