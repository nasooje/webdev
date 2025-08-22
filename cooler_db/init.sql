CREATE TABLE cooler.status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    is_run BOOLEAN DEFAULT TRUE
);
INSERT INTO cooler.status (name) VALUES ('a1'),('a2'),('a3'),('b1'),('b2'),('b3'),('c1'),('c2'),('c3');