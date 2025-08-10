CREATE TABLE atomic.status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    is_run BOOLEAN DEFAULT TRUE
);
INSERT INTO atomic.status (name) VALUES ('a'),('b'),('c');