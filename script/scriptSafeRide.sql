CREATE USER IF NOT EXISTS 'safeuser'@'localhost' IDENTIFIED BY 'eunaosei';
GRANT ALL PRIVILEGES ON saferide.* TO 'safeuser'@'localhost';
FLUSH PRIVILEGES;

SET  GLOBAL sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

DROP DATABASE IF EXISTS saferide;
CREATE DATABASE saferide;
use saferide;


CREATE TABLE `imagem` (
	`id` INT AUTO_INCREMENT,
	`caminho` VARCHAR(200) NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `usuario` (
	`id` INT AUTO_INCREMENT,
	`nome` VARCHAR(200) NULL,
	`email` VARCHAR(45) NULL,
	`senha` CHAR(64) NULL,
	`cpf` CHAR(15) NULL,
	`telefone` CHAR(11) NULL,
	`data_nascimento` DATE NULL,
	`tipo` INT NULL,
	`imagem_id` INT DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_usuario_imagem_idx` (`imagem_id` ASC) VISIBLE,
	CONSTRAINT `fk_usuario_imagem`
		FOREIGN KEY (`imagem_id`)
		REFERENCES `imagem` (`id`)
);


CREATE TABLE `endereco` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`latitude` VARCHAR(45) NULL DEFAULT NULL,
	`longitude` VARCHAR(45) NULL DEFAULT NULL,
    `nome` VARCHAR(200) NULL DEFAULT NULL,
	`cep` CHAR(8) NULL DEFAULT NULL,
	`numero` DECIMAL(4,0) NULL DEFAULT NULL,
	`complemento` VARCHAR(45) NULL DEFAULT NULL,
	`usuario_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_endereco_usuario_idx` (`usuario_id` ASC) VISIBLE,
	CONSTRAINT `fk_endereco_usuario`
		FOREIGN KEY (`usuario_id`)
		REFERENCES `usuario` (`id`)
);


CREATE TABLE `escola` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(300) NULL DEFAULT NULL,
	`endereco_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_escola_endereco_idx` (`endereco_id` ASC) VISIBLE,
	CONSTRAINT `fk_escola_endereco`
		FOREIGN KEY (`endereco_id`)
		REFERENCES `endereco` (`id`)
);
	

CREATE TABLE `contrato` (
	`id` INT AUTO_INCREMENT,
	`motorista_id` INT NOT NULL,
	`responsavel_id` INT NOT NULL,
	`data_inicio` DATE NULL,
    `data_fim` DATE NULL,
	`valor` DOUBLE NOT NULL,
	INDEX `fk_contrato_motorista_idx` (`motorista_id` ASC) VISIBLE,
	INDEX `fk_contrato_responsavel_idx` (`responsavel_id` ASC) VISIBLE,
	CONSTRAINT `fk_contrato_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_contrato_responsavel`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `usuario` (`id`),
	PRIMARY KEY (`id`)
);


CREATE TABLE `dependente` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(200) NULL,
	`data_nascimento` DATE NULL,
	`serie` VARCHAR(45) NULL,
	`escola_id` INT NOT NULL,
	`responsavel_id` INT NOT NULL,
	`motorista_id` INT DEFAULT NULL,
	`imagem_id` INT DEFAULT NULL,
	`contrato_id` INT DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_dependente_responsavel_idx` (`responsavel_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_responsavel`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `usuario` (`id`),
	INDEX `fk_dependente_escola_idx` (`escola_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_escola`
		FOREIGN KEY (`escola_id`)
		REFERENCES `escola` (`id`),
	INDEX `fk_dependente_motorista_idx` (`motorista_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`),
	INDEX `fk_dependente_imagem_idx` (`imagem_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_imagem`
		FOREIGN KEY (`imagem_id`)
		REFERENCES `imagem` (`id`),
	INDEX `fk_dependente_contrato_idx` (`contrato_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_contrato`
		FOREIGN KEY (`contrato_id`)
		REFERENCES `contrato` (`id`)
);
    

CREATE TABLE `transporte` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`placa` VARCHAR(45) NULL DEFAULT NULL,
	`cnpj` CHAR(14) NULL DEFAULT NULL,
	`cnh` CHAR(9) NULL DEFAULT NULL,
	`crm` VARCHAR(15) NULL DEFAULT NULL,
	`crmc` VARCHAR(20) NULL DEFAULT NULL,
	`usuario_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_transporte_usuario_idx` (`usuario_id` ASC) VISIBLE,
	CONSTRAINT `fk_transporte_usuario`
		FOREIGN KEY (`usuario_id`)
		REFERENCES `usuario` (`id`)
);


CREATE TABLE IF NOT EXISTS `trajeto` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`tipo` INT NOT NULL,
	`horario` INT NOT NULL,
	`dia_semana` INT NOT NULL,
	`escola_id` INT NOT NULL,
	`motorista_id` INT NOT NULL,
    `ativo` boolean,
	PRIMARY KEY (`id`),
	INDEX `fk_trajeto_escola_idx` (`escola_id` ASC) VISIBLE,
	CONSTRAINT `fk_trajeto_escola`
		FOREIGN KEY (`escola_id`)
		REFERENCES `escola` (`id`),
	INDEX `fk_trajeto_motorista_idx` (`motorista_id` ASC) VISIBLE,
	CONSTRAINT `fk_trajeto_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`)
);

CREATE TABLE `rota` (
	`id` INT AUTO_INCREMENT,
	`trajeto_id` INT NOT NULL,
	`dependente_id` INT NOT NULL,
	`endereco_id` INT NOT NULL,
    `status` INT NOT NULL,
    `horario` VARCHAR(5) NULL,
	PRIMARY KEY (`id`, `trajeto_id`, `dependente_id`, `endereco_id`),
	INDEX `fk_rota_trajeto_idx` (`dependente_id` ASC) VISIBLE,
	INDEX `fk_rota_dependente_idx` (`trajeto_id` ASC) VISIBLE,
	INDEX `fk_rota_endereco_idx` (`endereco_id` ASC) VISIBLE,
    CONSTRAINT `fk_rota_trajeto`
		FOREIGN KEY (`trajeto_id`)
		REFERENCES `trajeto` (`id`),
	CONSTRAINT `fk_rota_dependente`
		FOREIGN KEY (`dependente_id`)
		REFERENCES `dependente` (`id`),
	CONSTRAINT `fk_rota_endereco`
		FOREIGN KEY (`endereco_id`)
		REFERENCES `endereco` (`id`)
);


CREATE TABLE `conversa` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`responsavel_id` INT NOT NULL,
	`motorista_id` INT NOT NULL,
	PRIMARY KEY (`id`, `motorista_id`, `responsavel_id`),
	INDEX `fk_conversa_responsavel_idx` (`responsavel_id` ASC) VISIBLE,
	INDEX `fk_conversa_motorista_idx` (`motorista_id` ASC) VISIBLE,
	CONSTRAINT `fk_conversa_responsavel`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_conversa_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`)
);


CREATE TABLE `mensagem` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`data` DATETIME NULL,
	`status` INT NOT NULL,
	`trajeto_id` INT NULL,
	`conversa_id` INT NOT NULL,
	`usuario_id` INT NOT NULL,
	`dependente_id` INT NULL,
	`lida` BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (`id`),
	INDEX `fk_mensagem_trajeto_idx` (`trajeto_id` ASC) VISIBLE,
	INDEX `fk_mensagem_conversa_idx` (`conversa_id` ASC) VISIBLE,
	INDEX `fk_mensagem_usuario_idx` (`usuario_id` ASC) VISIBLE,
	INDEX `fk_mensagem_dependente_idx` (`dependente_id` ASC) VISIBLE,
    CONSTRAINT `fk_mensagem_trajeto`
		FOREIGN KEY (`trajeto_id`)
		REFERENCES `trajeto` (`id`),
	CONSTRAINT `fk_mensagem_conversa`
		FOREIGN KEY (`conversa_id`)
		REFERENCES `conversa` (`id`),
	CONSTRAINT `fk_mensagem_usuario`
		FOREIGN KEY (`usuario_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_mensagem_dependente`
		FOREIGN KEY (`dependente_id`)
		REFERENCES `dependente` (`id`)
);


CREATE TABLE `transporte_escola` (
  `transporte_id` INT NOT NULL,
  `escola_id` INT NOT NULL,
  PRIMARY KEY (`transporte_id`, `escola_id`),
  INDEX `fk_transporte_escola_transporte_idx` (`transporte_id` ASC) VISIBLE,
  INDEX `fk_transporte_escola_escola_idx` (`escola_id` ASC) VISIBLE,
  CONSTRAINT `fk_transporte_escola_transporte`
    FOREIGN KEY (`transporte_id`)
    REFERENCES `transporte` (`id`),
  CONSTRAINT `fk_transporte_escola_escola`
    FOREIGN KEY (`escola_id`)
    REFERENCES `escola` (`id`)
);

CREATE TABLE `pagamento` (
	`id` INT AUTO_INCREMENT,
	`contrato_id` INT NOT NULL,
	`data_criacao` DATE NULL,
	`data_vencimento` DATE NULL,
	`data_efetuacao` DATE NULL,
	`valor` DOUBLE NOT NULL,
	`tipo` INT NULL,
	`status` INT NULL,
	INDEX `fk_pagamento_contrato_idx` (`contrato_id` ASC) VISIBLE,
	CONSTRAINT `fk_pagamento_contrato`
		FOREIGN KEY (`contrato_id`)
		REFERENCES `contrato` (`id`),
	PRIMARY KEY (`id`)
);

CREATE TABLE `solicitacao` (
	`id` INT AUTO_INCREMENT,
	`responsavel_id` INT NOT NULL,
	`motorista_id` INT NOT NULL,
	`endereco_id` INT NOT NULL,
	`escola_id` INT NOT NULL,
	`dependente_id` INT NOT NULL,
    `periodo` INT NULL,
	`valor` DOUBLE NULL,
    `horario_ida` TIME NULL,
    `horario_volta` TIME NULL,
    `contrato_inicio` DATE NULL,
    `contrato_fim` DATE NULL,
    `tipo` VARCHAR(9) NULL,
    `dia_semana` VARCHAR(50) NULL,
	`status` INT NOT NULL,
	INDEX `fk_solicitacao_responsavel_idx` (`responsavel_id` ASC) VISIBLE,
	INDEX `fk_solicitacao_motorista_idx` (`motorista_id` ASC) VISIBLE,
	INDEX `fk_solicitacao_endereco_idx` (`endereco_id` ASC) VISIBLE,
	INDEX `fk_solicitacao_escola_idx` (`escola_id` ASC) VISIBLE,
	INDEX `fk_solicitacao_dependente_idx` (`dependente_id` ASC) VISIBLE,
	CONSTRAINT `fk_solicitacao_responsavel`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_solicitacao_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_solicitacao_endereco`
		FOREIGN KEY (`endereco_id`)
		REFERENCES `endereco` (`id`),
	CONSTRAINT `fk_solicitacao_escola`
		FOREIGN KEY (`escola_id`)
		REFERENCES `escola` (`id`),
	CONSTRAINT `fk_solicitacao_dependente`
		FOREIGN KEY (`dependente_id`)
		REFERENCES `dependente` (`id`),
	PRIMARY KEY (`id`)
);

CREATE TABLE `historico` (
	`id` INT AUTO_INCREMENT,
    `trajeto_id` INT NOT NULL,
    `horario_inicio` DATETIME NULL,
    `horario_fim` DATETIME NULL,
    INDEX `fk_historico_trajeto_idx` (`trajeto_id` ASC) VISIBLE,
    CONSTRAINT `fk_historico_trajeto`
		FOREIGN KEY (`trajeto_id`)
        REFERENCES `trajeto` (`id`),
	PRIMARY KEY (`id`)
);

CREATE TABLE `tempo_real` (
    `id_motorista` INT NOT NULL,
    `latitude` VARCHAR(200) NOT NULL,
    `longitude` VARCHAR(200) NOT NULL,
    `data` DATETIME NOT NULL,
    CONSTRAINT `fk_id_motorista` FOREIGN KEY (`id_motorista`)
    REFERENCES `usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- -----------------------------------------------------
-- View `Pagamento Status`
-- -----------------------------------------------------
CREATE VIEW v_pagamento_status AS
SELECT 
    COUNT(CASE WHEN p.status = 0 THEN 1 END) AS pago,
    COUNT(CASE WHEN p.status = 1 THEN 1 END) AS pendente,
    COUNT(CASE WHEN p.status = 2 THEN 1 END) AS atrasado
FROM 
    pagamento AS p;
    
CREATE VIEW v_renda_bruta_mes AS
SELECT
    DATE_FORMAT(data_vencimento, '%Y-%m-%d') AS data,
    SUM(valor) AS valor
FROM
    pagamento
GROUP BY
    data
ORDER BY
    STR_TO_DATE(data, '%Y-%m');
    
CREATE VIEW v_pagamentos_total_efetuados AS
SELECT
    DATE_FORMAT(data_vencimento, '%Y-%m-%d') AS data,
    COUNT(valor) AS total,
    COALESCE(SUM(CASE WHEN status = 0 THEN 1 END), 0) AS efetuados
FROM
    pagamento
GROUP BY
    data 
LIMIT 4;

INSERT INTO `imagem` (`id`, `caminho`) VALUES
(1, 'profile.png'),
(2, 'perfil-1.png'),
(3, 'perfil-2.png'),
(4, 'perfil-3.png'),
(5, 'perfil-4.png'),
(6, 'perfil-5.png'),
(7, 'perfil-6.png');

INSERT INTO `usuario` (`id`,`nome`, `email`, `senha`, `cpf`, `telefone`, `data_nascimento`, `tipo`, `imagem_id`) VALUES
(1, 'Carlos', 'carlos@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11923456789', '1981-02-02', 1, 2),
(2, 'Rogerio', 'rogerio@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678911', '11923456789', '1999-03-04', 0, 3),
(3, 'João', 'joao@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11923456789', '1981-02-02', 1, 4),
(4, 'Alessandra', 'alessandra@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11923456789', '1981-02-02', 1, 5),
(5, 'Patrícia', 'patricia@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11923456789', '1981-02-02', 1, 6),
(6, 'Paulo', 'paulo@email.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11923456789', '1981-02-02', 1, 7),
(100, 'AdminMotorista', 'safe20.ride24@gmail.com', 'admin@admin', '12345678950','11952034428', '2005-03-25', 0, 1),
(101, 'AdminResponsavel', 'safe20.ride24@gmail.com', 'admin@admin', '12345678950','11952034428', '2005-03-25', 1, 1);


INSERT INTO `endereco` (`id`,`latitude`, `longitude`, `cep`,`nome`, `numero`, `complemento`, `usuario_id`) VALUES
(1, '-23.551678073251345', '-46.65110050078054', '01305000','Rua Augusta', 539, 'Apto 2', 2),
(2, '-23.54792820606573', '-46.653211638769676', '01241001','Rua Piauí', 163, 'Apto 1', 1),
(3, '-23.554646777662235', '-46.651825482796056', '01308010','Rua Dr. Penaforte Mendes', 157, 'Apto 7', 1),
(4, '-23.556689244047583', '-46.6474597035435', '01003000','Rua Dr. Luís Barreto', 252, '', 3),
(5, '-23.557457363825513', '-46.644853331720974', '01328000',' Rua Conselheiro Carrão', 268, '', 4),
(6, '-23.54695743989084', '-46.653992631943865', '02327135','Rua Piauí', 295, 'Apto 5', 5),
(7, '-23.55159283805445', '-46.64869948726493', '01307000','Rua Frei Caneca', 92, 'Apto 6', 6),
(8, '-23.54868323670033', '-46.64764164655138', '01303040','Rua Gravataí', 30, 'Apto 8', 6),
(9, '-23.564652598297457', '-46.65071290330969', '01310100','Avenida Paulista', 900, '', 100),
(10, '-23.598948303991115', '-46.63624325422176', '04035001','Rua Domingos de Morais', 2565, 'Shopping Santa Cruz', 100);

INSERT INTO `escola` (`nome`, `endereco_id`) VALUES
('Objetivo Paulista', 9),
('Colégio Marista', 10);

INSERT INTO `dependente` (`nome`, `data_nascimento`, `serie`, `escola_id`, `responsavel_id`, `motorista_id`, `imagem_id`) VALUES
('Vinicius', '2010-01-01', '1ª série', 1, 1, 2, 1),
('Eduardo', '2010-02-02', '1ª série', 1, 1, 2, 1),
('Larrisa', '2010-03-03', '1ª série', 1, 3, 2, 1),
('Gustavo', '2010-04-04', '1ª série', 1, 4, 2, 1),
('Kauan', '2010-05-05', '1ª série', 1, 4, 2, 1),
('Bruna', '2010-06-06', '2ª série', 1, 5, 2, 1),
('Isabeli', '2010-07-07', '2ª série', 2, 5, 2, 1),
('Marcio', '2010-08-08', '2ª série', 2, 6, 2, 1),
('Cláudio', '2010-09-09', '2ª série', 2, 6, 2, 1),
('Maisa', '2010-10-10', '2ª série', 2, 6, 2, 1),
("Maria", "2010-01-30", "9° Ano Fundamental", 1, 1, NULL, 1);

INSERT INTO `transporte` (`placa`, `cnpj`, `cnh`, `crm`, `crmc`, `usuario_id`) VALUES
('ABC1234', '12345678000100', '123456789', '1234567', '12345678901234', 1);

INSERT INTO `transporte_escola` VALUES
(1, 1),
(1, 2);

INSERT INTO `trajeto` (`tipo`, `horario`, `dia_semana`, `escola_id`, `motorista_id`, `ativo`) VALUES
(0, 0, 0, 1, 2, false),
(1, 0, 0, 1, 2, false),
(0, 1, 0, 1, 2, false),
(1, 1, 0, 1, 2, false),
(0, 0, 0, 2, 2, false),
(1, 0, 0, 2, 2, false),
(0, 1, 0, 2, 2, false),
(1, 1, 0, 2, 2, false);

INSERT INTO `rota` (`trajeto_id`, `dependente_id`, `endereco_id`, `status`) VALUES
(1, 1, 1, 0),
(1, 2, 7, 0),
(1, 3, 3, 0),
(1, 4, 4, 0),
(1, 5, 4, 0),
(1, 6, 5, 0),
(2, 1, 1, 0),
(2, 2, 7, 0),
(2, 3, 3, 0),
(2, 4, 4, 0),
(2, 5, 4, 0),
(2, 6, 5, 0);

INSERT INTO `conversa` (`responsavel_id`, `motorista_id`) VALUES
(1, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2);

INSERT INTO `contrato` (`motorista_id`, `responsavel_id`, `data_inicio`, `data_fim`, `valor`) VALUES
(2, 1, '2024-07-15', '2025-07-15', 400.00),
(2, 3, '2024-05-01', '2025-05-01', 200.00),
(2, 4, '2024-01-16', '2025-01-16', 500.00),
(2, 5, '2024-01-03', '2025-01-03', 400.00),
(2, 6, '2024-01-19', '2025-01-19', 600.00);

INSERT INTO `pagamento` (`contrato_id`, `data_vencimento`, `data_efetuacao`, `valor`, `tipo`, `status`) VALUES
(1, '2024-07-10', '2024-07-01', 400.00, 0, 0),
(1, '2024-08-10', '2024-08-10', 400.00, 0, 0),
(1, '2024-09-10', '2024-09-25', 400.00, 0, 1),
(1, '2024-10-10', NULL, 400.00, 0, 1),
(1, '2024-11-10', NULL, 400.00, 0, 1),
(1, '2024-12-10', NULL, 400.00, 0, 1),
(2, '2024-05-10', '2024-06-01', 200.00, 0, 0),
(2, '2024-06-10', '2024-06-01', 200.00, 0, 0),
(2, '2024-07-10', '2024-06-29', 200.00, 0, 0),
(2, '2024-08-10', '2024-07-15', 200.00, 0, 0),
(2, '2024-09-10', '2024-08-15', 200.00, 0, 1),
(2, '2024-10-10', NULL, 200.00, 0, 1),
(2, '2024-11-10', NULL, 200.00, 0, 1),
(2, '2024-12-10', NULL, 200.00, 0, 1),
(3, '2024-01-10', '2024-01-10', 500.00, 0, 0),
(3, '2024-02-10', '2024-02-10', 500.00, 0, 0),
(3, '2024-03-10', '2024-03-10', 500.00, 0, 0),
(3, '2024-04-10', '2024-04-10', 500.00, 0, 0),
(3, '2024-05-10', '2024-05-10', 500.00, 0, 0),
(3, '2024-06-10', '2024-06-10', 500.00, 0, 0),
(3, '2024-07-10', '2024-07-10', 500.00, 0, 0),
(3, '2024-08-10', '2024-08-10', 500.00, 0, 0),
(3, '2024-09-10', NULL, 500.00, 0, 1),
(3, '2024-10-10', NULL, 500.00, 0, 1),
(3, '2024-11-10', NULL, 500.00, 0, 1),
(3, '2024-12-10', NULL, 500.00, 0, 1),
(4, '2024-01-03', '2024-01-01', 400.00, 0, 1),
(4, '2024-02-03', '2024-02-01', 400.00, 0, 1),
(4, '2024-03-03', '2024-03-01', 400.00, 0, 1),
(4, '2024-04-03', '2024-04-01', 400.00, 0, 1),
(4, '2024-05-03', '2024-05-01', 400.00, 0, 1),
(4, '2024-06-03', '2024-06-01', 400.00, 0, 1),
(4, '2024-07-03', '2024-07-01', 400.00, 0, 1),
(4, '2024-08-03', '2024-08-01', 400.00, 0, 1),
(4, '2024-09-03', NULL, 400.00, 0, 1),
(4, '2024-10-03', NULL, 400.00, 0, 1),
(4, '2024-11-03', NULL, 400.00, 0, 1),
(4, '2024-12-03', NULL, 400.00, 0, 1),
(5, '2024-01-19', '2024-01-10', 600.00, 1, 1),
(5, '2024-02-19', '2024-02-10', 600.00, 1, 1),
(5, '2024-03-19', '2024-03-10', 600.00, 1, 1),
(5, '2024-04-19', '2024-04-10', 600.00, 1, 1),
(5, '2024-05-19', '2024-05-10', 600.00, 1, 1),
(5, '2024-06-19', '2024-06-10', 600.00, 1, 1),
(5, '2024-07-19', '2024-08-01', 600.00, 1, 1),
(5, '2024-08-19', '2024-08-07', 200.00, 1, 1),
(5, '2024-09-19', NULL, 500.00, 1, 1),
(5, '2024-10-19', NULL, 500.00, 1, 1),
(5, '2024-11-19', NULL, 500.00, 1, 1),
(5, '2024-12-19', NULL, 500.00, 1, 1);

INSERT INTO `mensagem` (`data`, `status`, `conversa_id`, `usuario_id`, `dependente_id`) VALUES
(now(), 6, 1, 2, 1),
(now(), 6, 2, 2, 2),
(now(), 6, 3, 2, 3),
(now(), 6, 4, 2, 4),
(now(), 6, 5, 2, 5);	

INSERT INTO `mensagem` (`data`, `status`, `conversa_id`, `usuario_id`, `dependente_id`, `trajeto_id`) VALUES
('2024-10-10 12:24', 3, 1, 2, 1, 1),
('2024-10-10 13:00', 4, 1, 2, 1, 1),
('2024-10-10 17:30', 3, 1, 2, 1, 2),
('2024-10-10 13:00', 5, 1, 2, 1, 2);

insert into `historico` (`trajeto_id`, `horario_inicio`, `horario_fim`) VALUES
(1, '2024-10-10 05:11', '2024-10-10 06:59'),
(2, '2024-10-10 12:33', '2024-10-10 13:42');


CREATE VIEW v_listar_status_dependente_por_responsavel AS 
SELECT 
       hi.id as historico_id,
       hi.trajeto_id as trajeto_id,
       hi.horario_inicio as horario_inicio,
       hi.horario_fim as horario_fim,
       CASE WHEN tr.tipo = 0 THEN 'IDA' ELSE 'VOLTA' END AS trajeto_sentido,
       CASE WHEN tr.horario = 0 THEN 'MANHA' ELSE 'TARDE' END AS trajeto_horario,
       (SELECT nome FROM escola WHERE escola.id = tr.escola_id) AS de_es_nome,
       de.id AS de_id,
       de.nome AS de_nome,
       (SELECT nome FROM endereco WHERE endereco.id = ro.endereco_id) AS de_en_nome,
       us.id AS re_id,
       us.nome AS re_nome,
       me.status as mensagem_status
FROM historico hi
JOIN trajeto tr ON hi.trajeto_id = tr.id
JOIN mensagem me ON me.trajeto_id = tr.id
JOIN rota ro ON ro.trajeto_id = tr.id
JOIN dependente de ON ro.dependente_id = de.id
JOIN usuario us ON de.responsavel_id = us.id
GROUP BY 
      de_id;
          
          create view detalhe_pagamento_do_motorista as
          SELECT 
    u_responsavel.nome AS responsavel_nome,
    u_responsavel.email AS responsavel_email,
    p.data_criacao AS pagamento_data_criacao,
    p.data_vencimento AS pagamento_data_vencimento,
    p.data_efetuacao AS pagamento_data_efetuacao,
    CASE WHEN p.tipo = 0 THEN "PIX" ELSE "BOLETO" END AS pagamento_tipo,
    p.valor AS pagamento_valor,
    CASE WHEN p.status = 0 then "pago" 
    WHEN p.status = 1 then "pendente"
    ELSE "atrasado"
    END AS pagamento_status,
    u_motorista.id as motorista_id
FROM 
    pagamento p
JOIN 
    contrato c ON p.contrato_id = c.id
JOIN 
    usuario u_motorista ON c.motorista_id = u_motorista.id AND u_motorista.tipo = 0
JOIN 
    usuario u_responsavel ON c.responsavel_id = u_responsavel.id AND u_responsavel.tipo = 1;
			