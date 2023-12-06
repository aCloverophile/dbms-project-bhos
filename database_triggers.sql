-- TRIGGER 1
DELIMITER //
CREATE TRIGGER AfterInsertStudentCreateANewBookTakingRecord
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    INSERT INTO book_taking_count (student_id, count) VALUES (NEW.student_id, 0);
END //
DELIMITER ;

-- CHECK TRIGGER 1
INSERT INTO students (name, surname, admission_year, email, major_id) VALUES
('Ayaz', 'Alili', 2022, 'ayaz.alili.std@bhos.edu.az', 1000005);


-- TRIGGER 2
DELIMITER //
CREATE TRIGGER BeforeDeleteStudent
BEFORE DELETE ON students
FOR EACH ROW
BEGIN
    DECLARE student_book_count INT;
    SELECT COUNT(*) INTO student_book_count FROM students_book_taking WHERE student_id = OLD.student_id;
    IF student_book_count = 0 THEN
        DELETE FROM book_taking_count WHERE student_id = OLD.student_id;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete student. This student has borrowed books. Please return all books before deletion.';
    END IF;
END //
DELIMITER ;

-- CHECK TRIGGER 2
DELETE FROM students WHERE name = 'Ayaz' and surname = 'Alili';
DELETE FROM students WHERE name = 'Aliasgar' and surname = 'Aliyev';


-- TRIGGER 3
DELIMITER //
CREATE TRIGGER BeforeDeleteBook
BEFORE DELETE ON books
FOR EACH ROW
BEGIN
    DECLARE book_borrowed_count INT;
    SELECT COUNT(*) INTO book_borrowed_count FROM students_book_taking WHERE book_id = OLD.book_id;
    IF book_borrowed_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete book. It has been borrowed by students. Please wait for books to be returned before deletion.';
    END IF;
END //
DELIMITER ;

-- CHECK TRIGGER 3
DELETE FROM books WHERE book_name='The War of the Two Worlds';
INSERT INTO books (book_name, publishment_year, author_id, genre_id, count) VALUES 
('Test_Book', 1867, 100000013, 110, 29);
DELETE FROM books WHERE book_name='Test_Book';


-- TRIGGER 4
DELIMITER //
CREATE TRIGGER BeforeInsertStudentCheckAdmissionYear
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    DECLARE current_year YEAR;
    SET current_year = YEAR(NOW());

    IF NEW.admission_year > current_year OR NEW.admission_year < 2010 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid admission year.';
    END IF;
END //
DELIMITER ;

-- CHECK TRIGGER 4
INSERT INTO students (name, surname, admission_year, email, major_id) VALUES
('Test', 'Test', 2026, 'test.test.std@bhos.edu.az', 1000005);


-- TRIGGER 5
DELIMITER //
CREATE TRIGGER BeforeInsertBookCheckAuthorGenre
BEFORE INSERT ON books
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM authors WHERE author_id = NEW.author_id) OR
       NOT EXISTS (SELECT 1 FROM genres WHERE genre_id = NEW.genre_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid author or genre. Please provide them correctly.';
    ELSE
        IF NOT EXISTS (SELECT 1 FROM authors WHERE author_id = NEW.author_id) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid author. Please provide a valid author_id.';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM genres WHERE genre_id = NEW.genre_id) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid genre. Please provide a valid genre_id.';
        END IF;
    END IF;
END //
DELIMITER ;

-- CHECK TRIGGER 5
CALL InsertBook('Test Book', 2018, 200000000, 200, 21);
CALL InsertBook('Test Book', 2018, 200000000, 100, 21);
CALL InsertBook('Test Book', 2018, 100000000, 200, 21);
CALL InsertBook('Madonna in a Fur Coat', 1943, 100000024, 102, 65);