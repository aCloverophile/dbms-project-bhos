--------------------------------------------------------
-- ADDING FOREIGN KEYS

ALTER TABLE students 
ADD FOREIGN KEY (major_id) 
REFERENCES majors(major_id);

ALTER TABLE books 
ADD FOREIGN KEY (author_id) 
REFERENCES authors(author_id);

ALTER TABLE books 
ADD FOREIGN KEY (genre_id) 
REFERENCES genres(genre_id);

ALTER TABLE majors 
ADD FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE departments
ADD FOREIGN KEY (head_of_department)
REFERENCES teachers(teacher_id);

ALTER TABLE teachers
ADD FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE book_taking_count
ADD FOREIGN KEY (student_id)
REFERENCES students(student_id);

ALTER TABLE students_book_taking
ADD FOREIGN KEY (student_id) 
REFERENCES students(student_id);

ALTER TABLE students_book_returning
ADD FOREIGN KEY (student_id) 
REFERENCES students(student_id);

ALTER TABLE students_book_taking
ADD FOREIGN KEY (book_id)
REFERENCES books(book_id);

ALTER TABLE students_book_returning
ADD FOREIGN KEY (book_id) 
REFERENCES books(book_id);
--------------------------------------------------------
