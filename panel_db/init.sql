CREATE TABLE system.notice (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    author VARCHAR(255),
    created_at DATE
);

CREATE TABLE system.user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(255),
    email VARCHAR(100),
    phone VARCHAR(20),
    is_ready BOOLEAN DEFAULT FALSE
);

INSERT INTO system.notice (title, content, author, created_at) VALUES
('원자력 발전 관리 시스템입니다.', '원자력 발전 관리 시스템입니다. <br> 현재 2호기, 3호기, 4호기 운용이 가능합니다. <br> 발전기 운용에 각별히 주의해 주세요. <br> 사전에 협의가 되지 않은 발전기 운용은 징계 사유가 될 수 있습니다.', 'admin', (SELECT CONVERT(DATE_SUB(DATE_SUB(DATE_SUB(NOW(), INTERVAL 4 YEAR), INTERVAL 2 MONTH), INTERVAL 16 DAY), DATE))),
('외부 노출에 각별히 주의해 주세요.', '외부 노출에 각별히 주의해 주세요. <br> 최근 관리 시스템 외부 노출로 인한 사고 사례가 발생했습니다. <br> 임직원 여러분들께서는 이러한 사고가 발생하지 않도록 각별한 주의 부탁드립니다. <br> 인가되지 않은 사용자의 접근은 징계 사유가 될 수 있습니다.', 'admin', (SELECT CONVERT(DATE_SUB(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 11 MONTH), INTERVAL 8 DAY), DATE))),
('신규 관리 페이지를 이용해 주세요.', '신규 관리 페이지를 이용해 주세요. <br> 최근 신규 관리 페이지가 개발 완료되었습니다. <br> 현 관리 페이지의 사용 상에 보안상 문제점이 다수 존재하여 폐쇄가 결정되었습니다.', 'admin', (SELECT CONVERT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 5 MONTH), INTERVAL 22 DAY), DATE)));

INSERT INTO system.user (username, password, email, phone, is_ready) VALUES 
('admin','f95e7734ff099f7bd28dc7d36f533e23d8287105e1418d6ddf0663e02bb736c7','admin@admin.com','010-1111-1111', 1);