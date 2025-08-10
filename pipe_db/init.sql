CREATE TABLE pipe.status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    is_run BOOLEAN DEFAULT TRUE
);
INSERT INTO pipe.status (name) VALUES ('a1'),('a2'),('a3'),('a4'),('a5'),('b1'),('b2'),('b3'),('b4'),('b5'),('c1'),('c2'),('c3'),('c4'),('c5');