CREATE TABLE `notice` 
( 
    `id` INT AUTO_INCREMENT PRIMARY KEY, 
    `title` VARCHAR(255) NOT NULL, 
    `content` TEXT NOT NULL, 
    `author` VARCHAR(100) NOT NULL, 
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) default character set utf8 collate utf8_general_ci;

CREATE TABLE `QnA` 
( 
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `author` VARCHAR(100) NOT NULL,
    `password` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) default character set utf8 collate utf8_general_ci;

INSERT INTO `notice` (
    `title`,
    `content`,
    `author`
) VALUES 
    ("Launching a new project",
    "Hello, this is Vision Network. We are pleased to announce that Vision Network is launching a new project with innovative technologies and creative ideas. The project is aimed at developing smart city solutions and is designed to improve the efficiency of cities and the quality of life of their citizens. In particular, it will utilize Internet of Things (IoT) technologies to provide innovative services in various areas such as traffic management, energy conservation, public safety, and more. We plan to launch the first pilot of this project in the first half of next year, and will expand it nationwide in the future. We look forward to your continued interest and support. Thank you.",
    "admin"), 
    ("Homepage Relaunch",
    "Hello, this is Vision Network. We've redesigned our website to provide you with a better online experience. With a new look and improved functionality, you'll find it easier and faster to stay informed. We hope you enjoy the new look and feel free to let us know if you have any feedback. Thank you, and we look forward to being the best Vision Network ever.",
    "admin"),
    ('Announcing Fall 2024 Workshops',
    "Hello, this is Vision Network.We are pleased to announce that the second half of the 2024 all-employee workshop will be held from October 15-17, with various programs aimed at strengthening teamwork and developing employees' capabilities. If you would like to participate, please apply to your department team leader by September 30th. We'll do our best to make it fun and informative, and we hope you'll join us. Thank you.",
    'admin');