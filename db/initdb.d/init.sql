CREATE DATABASE IF NOT EXISTS safetydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE safetydb;

create table IF NOT EXISTS users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    profile_image VARCHAR(255) DEFAULT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (username, password, uuid) VALUES ('admin', '96acb6943eb53f659444cf3240d8b8130f80c2d4', '21fa125d-b72f-49f1-99b0-773aba77eb4e'); 

INSERT INTO users (username, password, uuid) VALUES ('test', 'password', '7b7951ae-7635-4dc2-a9c9-81baec6be983');

CREATE TABLE IF NOT EXISTS safety_training_programs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    activity_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    max_participants INT NOT NULL,
    current_participants INT DEFAULT 0,
    status ENUM('모집중', '마감', '완료') DEFAULT '모집중',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS safety_training_applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    program_id INT NOT NULL,
    user_id INT NOT NULL,
    status ENUM('신청', '취소', '참여완료') DEFAULT '신청',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES safety_training_programs(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_application (program_id, user_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO safety_training_programs (title, description, location, activity_date, start_time, end_time, max_participants) VALUES
('산업안전 기초교육', '근로자를 위한 기본적인 산업안전 규정 및 안전수칙에 대한 교육을 제공합니다.', '본원 교육실A', CURDATE() + INTERVAL 7 DAY, '09:00:00', '12:00:00', 20),
('화학물질 안전관리 교육', '화학물질 취급 및 관리에 대한 안전교육 프로그램입니다.', '안전교육센터 B', CURDATE() + INTERVAL 14 DAY, '10:00:00', '15:00:00', 15),
('건설현장 안전관리 특강', '건설현장에서의 안전관리 및 사고예방에 대한 전문교육입니다.', '온라인 화상교육', CURDATE() + INTERVAL 21 DAY, '14:00:00', '16:00:00', 30),
('중소기업 안전진단 컨설팅', '중소기업을 위한 안전진단 및 개선방안 컨설팅 서비스입니다.', '컨설팅실 C', CURDATE() + INTERVAL 10 DAY, '08:00:00', '16:00:00', 10),
('안전관리자 양성과정', '안전관리자 자격취득을 위한 전문교육 과정입니다.', '전문교육관', CURDATE() + INTERVAL 5 DAY, '13:00:00', '17:00:00', 25),
('개인보호구 착용법 실습', '개인보호구의 올바른 착용법과 관리방법에 대한 실습교육입니다.', '실습장 D', CURDATE() + INTERVAL 3 DAY, '10:00:00', '18:00:00', 12),
('산업재해 사례분석 세미나', '최근 산업재해 사례분석을 통한 예방교육 세미나입니다.', '세미나실 A', CURDATE() + INTERVAL 25 DAY, '09:00:00', '17:00:00', 40),
('외국인 근로자 안전교육', '외국인 근로자를 위한 맞춤형 산업안전교육 프로그램입니다.', '다국어교육실', CURDATE() + INTERVAL 12 DAY, '10:00:00', '14:00:00', 18);