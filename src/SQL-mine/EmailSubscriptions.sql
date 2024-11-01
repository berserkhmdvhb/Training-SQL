USE CustomerDataWareHouse;

DECLARE @emailToRemove NVARCHAR(255) = 'c@gmail.com';
DECLARE @EmailToAdd1 NVARCHAR(255) = 'new1@gmail.com';
DECLARE @EmailToAdd2 NVARCHAR(255) = 'new2@email.com';
DECLARE @name NVARCHAR(255) = 'Joanna';

-- Drop table if it exists
IF OBJECT_ID('students', 'U') IS NOT NULL
    DROP TABLE students;

-- Create a table
CREATE TABLE students (
    id BIGINT IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    gender NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL
);

-- Insert some values
INSERT INTO students VALUES
    ('Ryan', 'M', 'a@gmail.com;b@gmail.com;c@gmail.com;'),
    ('Joanna', 'F', 'a@gmail.com;b@gmail.com;c@gmail.com'),
    ('Ryan', 'M', 'a@gmail.com;c@gmail.com;b@gmail.com;'),
    ('Joanna', 'F', 'a@gmail.com;c@gmail.com;b@gmail.com'),
    ('Joanna', 'F', 'a@gmail.com;b@gmail.com;c@gmail.com;'),
    ('Joanna', 'F', 'a@gmail.com;cc@gmail.com;bb@gmail.com'),
    ('Joanna', 'F', 'd@gmail.com;c@gmail.com;e@gmail.com'),
    ('Joanna', 'F', 'd@gmail.com;c@gmail.com;e@gmail.com'),
    ('Joanna', 'F', 'd@gmail.com;c@gmail.com;b@gmail.com'),
    ('Joanna', 'F', 'f@gmail.com;g@gmail.com;h@gmail.com');

-- Remove emails with a semicolon at the end
UPDATE students
SET email = REPLACE(email, @emailToRemove + ';', '')
WHERE [name] LIKE @name;
-- Remove emails without a semicolon after them
UPDATE students
SET email = REPLACE(email, @emailToRemove, '')
WHERE [name] LIKE @name;
-- Add emails
UPDATE students
SET email = 
    CASE
        WHEN RIGHT(email, 1) = ';' AND [name] LIKE @name
            THEN CONCAT_WS(';', TRIM(TRAILING ';' FROM email), @EmailToAdd1, @EmailToAdd2)
        WHEN (NOT RIGHT(email, 1) = ';') AND [name] LIKE @name
            THEN CONCAT_WS(';', email, @EmailToAdd1, @EmailToAdd2)
        ELSE email
    END;

SELECT * FROM students