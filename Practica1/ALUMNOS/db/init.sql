CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE mensajes (id INT AUTO_INCREMENT PRIMARY KEY, mensaje VARCHAR(100));
INSERT INTO mensajes (mensaje) VALUES ('¡Hola desde MariaDB en Docker!');
