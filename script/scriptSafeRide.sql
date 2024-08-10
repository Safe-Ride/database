CREATE USER IF NOT EXISTS 'safeuser'@'localhost' IDENTIFIED BY 'eunaosei';
GRANT ALL PRIVILEGES ON saferide.* TO 'safeuser'@'localhost';
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS saferide;
CREATE DATABASE saferide;
use saferide;

-- -----------------------------------------------------
-- Table `Imagem`
-- -----------------------------------------------------
CREATE TABLE `imagem` (
	`id` INT AUTO_INCREMENT,
	`caminho` VARCHAR(200) NULL,
	PRIMARY KEY (`id`)
);
-- -----------------------------------------------------
-- Table `usuario`
-- -----------------------------------------------------
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

-- -----------------------------------------------------
-- Table `endereco`
-- -----------------------------------------------------
CREATE TABLE `endereco` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`latitude` VARCHAR(45) NULL DEFAULT NULL,
	`longitude` VARCHAR(45) NULL DEFAULT NULL,
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

-- -----------------------------------------------------
-- Table `escola`
-- -----------------------------------------------------
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
	
-- -----------------------------------------------------
-- Table `dependente`
-- -----------------------------------------------------
CREATE TABLE `dependente` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(200) NULL,
	`data_nascimento` DATE NULL,
	`serie` VARCHAR(45) NULL,
	`escola_id` INT NOT NULL,
	`responsavel_id` INT NOT NULL,
	`motorista_id` INT DEFAULT NULL,
	`imagem_id` INT DEFAULT NULL,
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
		REFERENCES `imagem` (`id`)
);
    
-- -----------------------------------------------------
-- Table `transporte`
-- -----------------------------------------------------
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

-- -----------------------------------------------------
-- Table `trajeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trajeto` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`tipo` INT NOT NULL,
	`dia_semana` INT NOT NULL,
	`escola_id` INT NOT NULL,
	`motorista_id` INT NOT NULL,
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

-- -----------------------------------------------------
-- Table `rota`
-- -----------------------------------------------------
CREATE TABLE `rota` (
	`rota_id` INT AUTO_INCREMENT,
	`trajeto_id` INT NOT NULL,
	`dependente_id` INT NOT NULL,
	`endereco_id` INT NOT NULL,
	PRIMARY KEY (`rota_id`, `trajeto_id`, `dependente_id`, `endereco_id`),
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

-- -----------------------------------------------------
-- Table `chat`
-- -----------------------------------------------------
CREATE TABLE `historico` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`responsavel_id` INT NOT NULL,
	`motorista_id` INT NOT NULL,
	PRIMARY KEY (`id`, `motorista_id`, `responsavel_id`),
	INDEX `fk_chat_responsavel_idx` (`responsavel_id` ASC) VISIBLE,
	INDEX `fk_chat_motorista_idx` (`motorista_id` ASC) VISIBLE,
	CONSTRAINT `fk_chat_responsavel`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_chat_motorista`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`)
);

-- -----------------------------------------------------
-- Table `mensagem`
-- -----------------------------------------------------
CREATE TABLE `mensagem` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`data` DATETIME NULL,
	`status` INT NOT NULL,
	`historico_id` INT NOT NULL,
	`usuario_id` INT NOT NULL,
	`dependente_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_mensagem_historico_idx` (`historico_id` ASC) VISIBLE,
	INDEX `fk_mensagem_usuario_idx` (`usuario_id` ASC) VISIBLE,
	INDEX `fk_mensagem_dependente_idx` (`dependente_id` ASC) VISIBLE,
	CONSTRAINT `fk_mensagem_historico`
		FOREIGN KEY (`historico_id`)
		REFERENCES `historico` (`id`),
	CONSTRAINT `fk_mensagem_usuario`
		FOREIGN KEY (`usuario_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_mensagem_dependente`
		FOREIGN KEY (`dependente_id`)
		REFERENCES `dependente` (`id`)
);

-- -----------------------------------------------------
-- Table `transporte_escola`
-- -----------------------------------------------------
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

-- -----------------------------------------------------
-- Table `Pagamento`
-- -----------------------------------------------------
CREATE TABLE `pagamento` (
	`id` INT AUTO_INCREMENT,
	`cobrador_id` INT NOT NULL,
	`pagador_id` INT NOT NULL,
	`data_criacao` DATE NULL,
	`data_vencimento` DATE NULL,
	`data_efetuacao` DATE NULL,
	`valor` DOUBLE NOT NULL,
	`tipo` INT NULL,
	`situacao` INT NULL,
	INDEX `fk_pagamento_cobrador_idx` (`cobrador_id` ASC) VISIBLE,
	INDEX `fk_pagamento_pagador_idx` (`pagador_id` ASC) VISIBLE,
	CONSTRAINT `fk_pagamento_cobrador`
		FOREIGN KEY (`cobrador_id`)
		REFERENCES `usuario` (`id`),
	CONSTRAINT `fk_pagamento_pagador`
		FOREIGN KEY (`pagador_id`)
		REFERENCES `usuario` (`id`),
	PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- View `Pagamento Status`
-- -----------------------------------------------------
CREATE VIEW v_pagamento_status AS
SELECT 
    COUNT(CASE WHEN p.situacao = 0 THEN 1 END) AS pago,
    COUNT(CASE WHEN p.situacao = 1 THEN 1 END) AS pendente,
    COUNT(CASE WHEN p.situacao = 2 THEN 1 END) AS atrasado
FROM 
    pagamento AS p;
    
-- -----------------------------------------------------
-- View `Renda Bruta Por Mes`
-- -----------------------------------------------------
CREATE VIEW v_renda_bruta_mes AS
SELECT
    DATE_FORMAT(data_criacao, '%Y-%m-01') AS data,
    SUM(valor) AS valor
FROM
    pagamento
GROUP BY
    data
ORDER BY
    STR_TO_DATE(data, '%Y-%m');
    
-- -----------------------------------------------------
-- View `Pagamentos Totais E Efetuados`
-- -----------------------------------------------------
CREATE VIEW v_pagamentos_total_efetuados AS
SELECT
    DATE_FORMAT(data_criacao, '%Y-%m-01') AS data,
    COUNT(valor) AS total,
    COALESCE(SUM(CASE WHEN situacao = 0 THEN 1 END), 0) AS efetuados
FROM
    pagamento
GROUP BY
    data 
LIMIT 4;

INSERT INTO imagem VALUES(1, 'profile.png')

-- Inserindo registros na tabela `imagem`
INSERT INTO `imagem` (`caminho`) VALUES
('profile.jpg');

-- Inserindo registros na tabela `usuario`
INSERT INTO `usuario` (`nome`, `email`, `senha`, `cpf`, `telefone`, `data_nascimento`, `tipo`, `imagem_id`) VALUES
('Motorista 2', 'motorista2@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678902', '11999999992', '1981-02-02', 0, 1),
('Motorista 3', 'motorista3@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678903', '11999999993', '1982-03-03', 0, 1),
('Motorista 1', 'motorista1@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678901', '11999999991', '1980-01-01', 0, 1),
('Motorista 4', 'motorista4@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678904', '11999999994', '1983-04-04', 0, 1),
('Motorista 5', 'motorista5@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678905', '11999999995', '1984-05-05', 0, 1),
('Responsável 1', 'responsavel1@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678906', '11999999996', '1985-06-06', 1, 1),
('Responsável 2', 'responsavel2@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678907', '11999999997', '1986-07-07', 1, 1),
('Responsável 3', 'responsavel3@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678908', '11999999998', '1987-08-08', 1, 1),
('Responsável 4', 'responsavel4@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678909', '11999999999', '1988-09-09', 1, 1),
('Responsável 5', 'responsavel5@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678910', '11999999900', '1989-10-10', 1, 1),
('Responsável 6', 'responsavel6@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678911', '11999999911', '1990-11-11', 1, 1),
('Responsável 7', 'responsavel7@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678912', '11999999912', '1991-12-12', 1, 1),
('Responsável 8', 'responsavel8@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678913', '11999999913', '1992-01-13', 1, 1),
('Responsável 9', 'responsavel9@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678914', '11999999914', '1993-02-14', 1, 1),
('Responsável 10', 'responsavel10@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678915', '11999999915', '1994-03-15', 1, 1),
('Responsável 11', 'responsavel11@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678916', '11999999916', '1995-04-16', 1, 1),
('Responsável 12', 'responsavel12@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678917', '11999999917', '1996-05-17', 1, 1),
('Responsável 13', 'responsavel13@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678918', '11999999918', '1997-06-18', 1, 1),
('Responsável 14', 'responsavel14@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678919', '11999999919', '1998-07-19', 1, 1),
('Responsável 15', 'responsavel15@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678920', '11999999920', '1999-08-20', 1, 1),
('Responsável 16', 'responsavel16@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678921', '11999999921', '2000-09-21', 1, 1),
('Responsável 17', 'responsavel17@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678922', '11999999922', '2001-10-22', 1, 1),
('Responsável 18', 'responsavel18@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678923', '11999999923', '2002-11-23', 1, 1),
('Responsável 19', 'responsavel19@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678924', '11999999924', '2003-12-24', 1, 1),
('Responsável 20', 'responsavel20@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678925', '11999999925', '2004-01-25', 1, 1),
('Responsável 21', 'responsavel21@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678926', '11999999926', '2005-02-26', 1, 1),
('Responsável 22', 'responsavel22@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678927', '11999999927', '2006-03-27', 1, 1),
('Responsável 23', 'responsavel23@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678928', '11999999928', '2007-04-28', 1, 1),
('Responsável 24', 'responsavel24@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678929', '11999999929', '2008-05-29', 1, 1),
('Responsável 25', 'responsavel25@example.com', '$2a$10$v7v/un8EipcWCr18p.ZNQOXrWxvyOcgTrrx8emLhbtDQj5uZH75nu', '12345678930', '11999999930', '2009-06-30', 1, 1),
('AdminMotorista', 'safe20.ride24@gmail.com', 'admin@admin', '12345678950','11952034428', '2005-03-25', 0,1),
('AdminResponsavel', 'safe20.ride24@gmail.com', 'admin@admin', '12345678950','11952034428', '2005-03-25', 1,1);


-- Inserindo registros na tabela `endereco`
INSERT INTO `endereco` (`latitude`, `longitude`, `cep`, `numero`, `complemento`, `usuario_id`) VALUES
('23.5505', '46.6333', '01001000', 1, 'Apto 1', 1),
('23.5515', '46.6343', '01002000', 2, 'Apto 2', 2),
('23.5525', '46.6353', '01003000', 3, 'Apto 3', 3),
('23.5535', '46.6363', '01004000', 4, 'Apto 4', 4),
('23.5545', '46.6373', '01005000', 5, 'Apto 5', 5),
('23.5555', '46.6383', '01006000', 6, 'Apto 6', 6),
('23.5565', '46.6393', '01007000', 7, 'Apto 7', 7),
('23.5575', '46.6403', '01008000', 8, 'Apto 8', 8),
('23.5585', '46.6413', '01009000', 9, 'Apto 9', 9),
('23.5595', '46.6423', '01010000', 10, 'Apto 10', 10),
('23.5605', '46.6433', '01011000', 11, 'Apto 11', 11),
('23.5615', '46.6443', '01012000', 12, 'Apto 12', 12),
('23.5625', '46.6453', '01013000', 13, 'Apto 13', 13),
('23.5635', '46.6463', '01014000', 14, 'Apto 14', 14),
('23.5645', '46.6473', '01015000', 15, 'Apto 15', 15),
('23.5655', '46.6483', '01016000', 16, 'Apto 16', 16),
('23.5665', '46.6493', '01017000', 17, 'Apto 17', 17),
('23.5675', '46.6503', '01018000', 18, 'Apto 18', 18),
('23.5685', '46.6513', '01019000', 19, 'Apto 19', 19),
('23.5695', '46.6523', '01020000', 20, 'Apto 20', 20),
('23.5705', '46.6533', '01021000', 21, 'Apto 21', 6),
('23.5715', '46.6543', '01022000', 22, 'Apto 22', 7),
('23.5725', '46.6553', '01023000', 23, 'Apto 23', 8),
('23.5735', '46.6563', '01024000', 24, 'Apto 24', 9),
('23.5745', '46.6573', '01025000', 25, 'Apto 25', 10),
('23.5755', '46.6583', '01026000', 26, 'Apto 26', 6),
('23.5765', '46.6593', '01027000', 27, 'Apto 27', 7),
('23.5775', '46.6603', '01028000', 28, 'Apto 28', 11),
('23.5785', '46.6613', '01029000', 29, 'Apto 29', 12),
('23.5795', '46.6623', '01030000', 30, 'Apto 30', 13);

-- Inserindo registros na tabela `escola`
INSERT INTO `escola` (`nome`, `endereco_id`) VALUES
('Escola 1', 1),
('Escola 2', 2),
('Escola 3', 3),
('Escola 4', 4),
('Escola 5', 5);
-- Inserindo registros na tabela `dependente`
INSERT INTO `dependente` (`nome`, `data_nascimento`, `serie`, `escola_id`, `responsavel_id`, `motorista_id`, `imagem_id`) VALUES
('Dependente 1', '2010-01-01', '1ª série', 1, 6, 1, 1),
('Dependente 2', '2010-02-02', '1ª série', 2, 7, 2, 1),
('Dependente 3', '2010-03-03', '1ª série', 3, 8, 3, 1),
('Dependente 4', '2010-04-04', '1ª série', 4, 9, 4, 1),
('Dependente 5', '2010-05-05', '1ª série', 5, 10, 5, 1),
('Dependente 6', '2010-06-06', '2ª série', 1, 11, 1, 1),
('Dependente 7', '2010-07-07', '2ª série', 2, 12, 2, 1),
('Dependente 8', '2010-08-08', '2ª série', 3, 13, 3, 1),
('Dependente 9', '2010-09-09', '2ª série', 4, 14, 4, 1),
('Dependente 10', '2010-10-10', '2ª série', 5, 15, 5, 1),
('Dependente 11', '2010-11-11', '3ª série', 1, 16, 1, 1),
('Dependente 12', '2010-12-12', '3ª série', 2, 17, 2, 1),
('Dependente 13', '2011-01-01', '3ª série', 3, 18, 3, 1),
('Dependente 14', '2011-02-02', '3ª série', 4, 19, 4, 1),
('Dependente 15', '2011-03-03', '3ª série', 5, 20, 5, 1),
('Dependente 16', '2011-04-04', '4ª série', 1, 21, 1, 1),
('Dependente 17', '2011-05-05', '4ª série', 2, 22, 2, 1),
('Dependente 18', '2011-06-06', '4ª série', 3, 23, 3, 1),
('Dependente 19', '2011-07-07', '4ª série', 4, 24, 4, 1),
('Dependente 20', '2011-08-08', '4ª série', 5, 25, 5, 1),
('Dependente 21', '2011-09-09', '5ª série', 1, 26, 1, 1),
('Dependente 22', '2011-10-10', '5ª série', 2, 27, 2, 1),
('Dependente 23', '2011-11-11', '5ª série', 3, 28, 3, 1),
('Dependente 24', '2011-12-12', '5ª série', 4, 29, 4, 1),
('Dependente 25', '2012-01-01', '5ª série', 5, 30, 5, 1),
('Dependente 26', '2010-05-22', '6ª série', 1, 6, 1, 1),
('Dependente 27', '2011-03-30', '6ª série', 2, 6, 1, 1),
('Dependente 28', '2019-11-05', '2ª série', 2, 6, 1, 1),
('Dependente 29', '2014-02-02', '6ª série', 3, 6, 3, 1),
('Dependente 30', '2011-02-11', '6ª série', 5, 6, 3, 1),
('Dependente 31', '2010-04-02', '6ª série', 1, 6, 1, 1),
('Dependente 32', '2012-03-03', '6ª série', 2, 7, 2, 1),
('Dependente 33', '2012-04-04', '6ª série', 3, 8, 3, 1),
('Dependente 34', '2012-05-05', '6ª série', 4, 9, 4, 1),
('Dependente 35', '2012-06-06', '6ª série', 5, 10, 5, 1);

-- Inserindo registros na tabela `transporte`
INSERT INTO `transporte` (`placa`, `cnpj`, `cnh`, `crm`, `crmc`, `usuario_id`) VALUES
('ABC1234', '12345678000100', '123456789', '1234567', '12345678901234', 1),
('DEF5678', '23456789000111', '234567890', '2345678', '23456789012345', 2),
('GHI9012', '34567890000122', '345678901', '3456789', '34567890123456', 3),
('JKL3456', '45678901000133', '456789012', '4567890', '45678901234567', 4),
('MNO7890', '56789012000144', '567890123', '5678901', '56789012345678', 5);

-- Inserindo registros na tabela `trajeto`
INSERT INTO `trajeto` (`tipo`, `dia_semana`, `escola_id`, `motorista_id`) VALUES
-- IDA, SEGUNDA, ESCOLA 1, MOTORISTA 1
(0, 0, 1, 1),
-- VOLTA, SEGUNDA, ESCOLA 1, MOTORISTA 1
(1, 0, 1, 1),
-- IDA, TERÇA, ESCOLA 1, MOTORISTA 1
(0, 1, 1, 1),
-- VOLTA, TERÇA, ESCOLA 1, MOTORISTA 1
(1, 1, 1, 1),
-- IDA, QUARTA, ESCOLA 1, MOTORISTA 1
(0, 2, 1, 1),
-- VOLTA, QUARTA, ESCOLA 1, MOTORISTA 1
(1, 2, 1, 1),
-- IDA, QUINTA, ESCOLA 1, MOTORISTA 1
(0, 3, 1, 1),
-- VOLTA, QUINTA, ESCOLA 1, MOTORISTA 1
(1, 3, 1, 1),
-- IDA, SEXTA, ESCOLA 1, MOTORISTA 1
(0, 4, 1, 1),
-- VOLTA, SEXTA, ESCOLA 1, MOTORISTA 1
(1, 4, 1, 1),
-- IDA, SEGUNDA, ESCOLA 2, MOTORISTA 2
(0, 0, 2, 2),
-- VOLTA, SEGUNDA, ESCOLA 2, MOTORISTA 2
(1, 0, 2, 2),
-- IDA, TERÇA, ESCOLA 2, MOTORISTA 2
(0, 1, 2, 2),
-- VOLTA, TERÇA, ESCOLA 2, MOTORISTA 2
(1, 1, 2, 2),
-- IDA, QUARTA, ESCOLA 2, MOTORISTA 2
(0, 2, 2, 2),
-- VOLTA, QUARTA, ESCOLA 2, MOTORISTA 2
(1, 2, 2, 2),
-- IDA, QUINTA, ESCOLA 2, MOTORISTA 2
(0, 3, 2, 2),
-- VOLTA, QUINTA, ESCOLA 2, MOTORISTA 2
(1, 3, 2, 2),
-- IDA, SEXTA, ESCOLA 2, MOTORISTA 2
(0, 4, 2, 2),
-- VOLTA, SEXTA, ESCOLA 2, MOTORISTA 2
(1, 4, 2, 2),
-- IDA, SEGUNDA, ESCOLA 3, MOTORISTA 3
(0, 0, 3, 3),
-- VOLTA, SEGUNDA, ESCOLA 3, MOTORISTA 3
(1, 0, 3, 3),
-- IDA, TERÇA, ESCOLA 3, MOTORISTA 3
(0, 1, 3, 3),
-- VOLTA, TERÇA, ESCOLA 3, MOTORISTA 3
(1, 1, 3, 3),
-- IDA, QUARTA, ESCOLA 3, MOTORISTA 3
(0, 2, 3, 3),
-- VOLTA, QUARTA, ESCOLA 3, MOTORISTA 3
(1, 2, 3, 3),
-- IDA, QUINTA, ESCOLA 3, MOTORISTA 3
(0, 3, 3, 3),
-- VOLTA, QUINTA, ESCOLA 3, MOTORISTA 3
(1, 3, 3, 3),
-- IDA, SEXTA, ESCOLA 3, MOTORISTA 3
(0, 4, 3, 3),
-- VOLTA, SEXTA, ESCOLA 3, MOTORISTA 3
(1, 4, 3, 3),
-- IDA, SEGUNDA, ESCOLA 3, MOTORISTA 4
(0, 0, 3, 4),
-- VOLTA, SEGUNDA, ESCOLA 3, MOTORISTA 4
(1, 0, 3, 4),
-- IDA, TERÇA, ESCOLA 3, MOTORISTA 4
(0, 1, 3, 4),
-- VOLTA, TERÇA, ESCOLA 3, MOTORISTA 4
(1, 1, 3, 4),
-- IDA, QUARTA, ESCOLA 3, MOTORISTA 4
(0, 2, 3, 4),
-- VOLTA, QUARTA, ESCOLA 3, MOTORISTA 4
(1, 2, 3, 4),
-- IDA, QUINTA, ESCOLA 3, MOTORISTA 4
(0, 3, 3, 4),
-- VOLTA, QUINTA, ESCOLA 3, MOTORISTA 4
(1, 3, 3, 4),
-- IDA, SEXTA, ESCOLA 3, MOTORISTA 4
(0, 4, 3, 4),
-- VOLTA, SEXTA, ESCOLA 3, MOTORISTA 4
(1, 4, 3, 4),
-- IDA, SEGUNDA, ESCOLA 4, MOTORISTA 4
(0, 0, 4, 4),
-- VOLTA, SEGUNDA, ESCOLA 4, MOTORISTA 4
(1, 0, 4, 4),
-- IDA, TERÇA, ESCOLA 4, MOTORISTA 4
(0, 1, 4, 4),
-- VOLTA, TERÇA, ESCOLA 4, MOTORISTA 4
(1, 1, 4, 4),
-- IDA, QUARTA, ESCOLA 4, MOTORISTA 4
(0, 2, 4, 4),
-- VOLTA, QUARTA, ESCOLA 4, MOTORISTA 4
(1, 2, 4, 4),
-- IDA, QUINTA, ESCOLA 4, MOTORISTA 4
(0, 3, 4, 4),
-- VOLTA, QUINTA, ESCOLA 4, MOTORISTA 4
(1, 3, 4, 4),
-- IDA, SEXTA, ESCOLA 4, MOTORISTA 4
(0, 4, 4, 4),
-- VOLTA, SEXTA, ESCOLA 4, MOTORISTA 4
(1, 4, 4, 4),
-- IDA, SEGUNDA, ESCOLA 5, MOTORISTA 4
(0, 0, 5, 4),
-- VOLTA, SEGUNDA, ESCOLA 5, MOTORISTA 4
(1, 0, 5, 4),
-- IDA, TERÇA, ESCOLA 5, MOTORISTA 4
(0, 1, 5, 4),
-- VOLTA, TERÇA, ESCOLA 5, MOTORISTA 4
(1, 1, 5, 4),
-- IDA, QUARTA, ESCOLA 5, MOTORISTA 4
(0, 2, 5, 4),
-- VOLTA, QUARTA, ESCOLA 5, MOTORISTA 4
(1, 2, 5, 4),
-- IDA, QUINTA, ESCOLA 5, MOTORISTA 4
(0, 3, 5, 4),
-- VOLTA, QUINTA, ESCOLA 5, MOTORISTA 4
(1, 3, 5, 4),
-- IDA, SEXTA, ESCOLA 5, MOTORISTA 4
(0, 4, 5, 4),
-- VOLTA, SEXTA, ESCOLA 5, MOTORISTA 4
(1, 4, 5, 4),
-- IDA, SEGUNDA, ESCOLA 5, MOTORISTA 5
(0, 0, 5, 5),
-- VOLTA, SEGUNDA, ESCOLA 5, MOTORISTA 5
(1, 0, 5, 5),
-- IDA, TERÇA, ESCOLA 5, MOTORISTA 5
(0, 1, 5, 5),
-- VOLTA, TERÇA, ESCOLA 5, MOTORISTA 5
(1, 1, 5, 5),
-- IDA, QUARTA, ESCOLA 5, MOTORISTA 5
(0, 2, 5, 5),
-- VOLTA, QUARTA, ESCOLA 5, MOTORISTA 5
(1, 2, 5, 5),
-- IDA, QUINTA, ESCOLA 5, MOTORISTA 5
(0, 3, 5, 5),
-- VOLTA, QUINTA, ESCOLA 5, MOTORISTA 5
(1, 3, 5, 5),
-- IDA, SEXTA, ESCOLA 5, MOTORISTA 5
(0, 4, 5, 5),
-- VOLTA, SEXTA, ESCOLA 5, MOTORISTA 5
(1, 4, 5, 5);

-- Inserindo registros na tabela `rota`
INSERT INTO `rota` (`trajeto_id`, `dependente_id`, `endereco_id`) VALUES
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 1, MOTORISTA 1
(1, 1, 6),
(1, 2, 7),
(1, 3, 8),
(1, 4, 9),
(1, 5, 10),
(1, 6, 11),
(1, 7, 12),
(1, 8, 13),
(1, 9, 14),
(1, 10, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 1, MOTORISTA 1
(2, 1, 16),
(2, 2, 17),
(2, 3, 18),
(2, 4, 19),
(2, 5, 20),
(2, 6, 21),
(2, 7, 22),
(2, 8, 23),
(2, 9, 24),
(2, 10, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 1, MOTORISTA 1
(3, 11, 6),
(3, 12, 7),
(3, 13, 8),
(3, 14, 9),
(3, 15, 10),
(3, 16, 11),
(3, 17, 12),
(3, 18, 13),
(3, 19, 14),
(3, 20, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 1, MOTORISTA 1
(4, 11, 16),
(4, 12, 17),
(4, 13, 18),
(4, 14, 19),
(4, 15, 20),
(4, 16, 21),
(4, 17, 22),
(4, 18, 23),
(4, 19, 24),
(4, 20, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 1, MOTORISTA 1
(5, 21, 6),
(5, 22, 7),
(5, 23, 8),
(5, 24, 9),
(5, 25, 10),
(5, 26, 11),
(5, 27, 12),
(5, 28, 13),
(5, 29, 14),
(5, 30, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 1, MOTORISTA 1
(6, 21, 16),
(6, 22, 17),
(6, 23, 18),
(6, 24, 19),
(6, 25, 20),
(6, 26, 21),
(6, 27, 22),
(6, 28, 23),
(6, 29, 24),
(6, 30, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 1, MOTORISTA 1
(7, 31, 6),
(7, 32, 7),
(7, 33, 8),
(7, 34, 9),
(7, 35, 10),
(7, 1, 11),
(7, 2, 12),
(7, 3, 13),
(7, 4, 14),
(7, 5, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 1, MOTORISTA 1
(8, 31, 16),
(8, 32, 17),
(8, 33, 18),
(8, 34, 19),
(8, 35, 20),
(8, 1, 21),
(8, 2, 22),
(8, 3, 23),
(8, 4, 24),
(8, 5, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 1, MOTORISTA 1
(9, 6, 6),
(9, 7, 7),
(9, 8, 8),
(9, 9, 9),
(9, 10, 10),
(9, 11, 11),
(9, 12, 12),
(9, 13, 13),
(9, 14, 14),
(9, 15, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 1, MOTORISTA 1
(10, 6, 16),
(10, 7, 17),
(10, 8, 18),
(10, 9, 19),
(10, 10, 20),
(10, 11, 21),
(10, 12, 22),
(10, 13, 23),
(10, 14, 24),
(10, 15, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 2, MOTORISTA 2
(11, 16, 6),
(11, 17, 7),
(11, 18, 8),
(11, 19, 9),
(11, 20, 10),
(11, 21, 11),
(11, 22, 12),
(11, 23, 13),
(11, 24, 14),
(11, 25, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 2, MOTORISTA 2
(12, 16, 16),
(12, 17, 17),
(12, 18, 18),
(12, 19, 19),
(12, 20, 20),
(12, 21, 21),
(12, 22, 22),
(12, 23, 23),
(12, 24, 24),
(12, 25, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 2, MOTORISTA 2
(13, 26, 6),
(13, 27, 7),
(13, 28, 8),
(13, 29, 9),
(13, 30, 10),
(13, 31, 11),
(13, 32, 12),
(13, 33, 13),
(13, 34, 14),
(13, 35, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 2, MOTORISTA 2
(14, 26, 16),
(14, 27, 17),
(14, 28, 18),
(14, 29, 19),
(14, 30, 20),
(14, 31, 21),
(14, 32, 22),
(14, 33, 23),
(14, 34, 24),
(14, 35, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 2, MOTORISTA 2
(15, 1, 6),
(15, 2, 7),
(15, 3, 8),
(15, 4, 9),
(15, 5, 10),
(15, 6, 11),
(15, 7, 12),
(15, 8, 13),
(15, 9, 14),
(15, 10, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 2, MOTORISTA 2
(16, 1, 16),
(16, 2, 17),
(16, 3, 18),
(16, 4, 19),
(16, 5, 20),
(16, 6, 21),
(16, 7, 22),
(16, 8, 23),
(16, 9, 24),
(16, 10, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 2, MOTORISTA 2
(17, 11, 6),
(17, 12, 7),
(17, 13, 8),
(17, 14, 9),
(17, 15, 10),
(17, 16, 11),
(17, 17, 12),
(17, 18, 13),
(17, 19, 14),
(17, 20, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 2, MOTORISTA 2
(18, 11, 16),
(18, 12, 17),
(18, 13, 18),
(18, 14, 19),
(18, 15, 20),
(18, 16, 21),
(18, 17, 22),
(18, 18, 23),
(18, 19, 24),
(18, 20, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 2, MOTORISTA 2
(19, 21, 6),
(19, 22, 7),
(19, 23, 8),
(19, 24, 9),
(19, 25, 10),
(19, 26, 11),
(19, 27, 12),
(19, 28, 13),
(19, 29, 14),
(19, 30, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 2, MOTORISTA 2
(20, 21, 16),
(20, 22, 17),
(20, 23, 18),
(20, 24, 19),
(20, 25, 20),
(20, 26, 21),
(20, 27, 22),
(20, 28, 23),
(20, 29, 24),
(20, 30, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 3, MOTORISTA 3
(21, 1, 6),
(21, 2, 7),
(21, 3, 8),
(21, 4, 9),
(21, 5, 10),
(21, 6, 11),
(21, 7, 12),
(21, 8, 13),
(21, 9, 14),
(21, 10, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 3, MOTORISTA 3
(22, 1, 16),
(22, 2, 17),
(22, 3, 18),
(22, 4, 19),
(22, 5, 20),
(22, 6, 21),
(22, 7, 22),
(22, 8, 23),
(22, 9, 24),
(22, 10, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 3, MOTORISTA 3
(23, 11, 6),
(23, 12, 7),
(23, 13, 8),
(23, 14, 9),
(23, 15, 10),
(23, 16, 11),
(23, 17, 12),
(23, 18, 13),
(23, 19, 14),
(23, 20, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 3, MOTORISTA 3
(24, 11, 16),
(24, 12, 17),
(24, 13, 18),
(24, 14, 19),
(24, 15, 20),
(24, 16, 21),
(24, 17, 22),
(24, 18, 23),
(24, 19, 24),
(24, 20, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 3, MOTORISTA 3
(25, 21, 6),
(25, 22, 7),
(25, 23, 8),
(25, 24, 9),
(25, 25, 10),
(25, 26, 11),
(25, 27, 12),
(25, 28, 13),
(25, 29, 14),
(25, 30, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 3, MOTORISTA 3
(26, 21, 16),
(26, 22, 17),
(26, 23, 18),
(26, 24, 19),
(26, 25, 20),
(26, 26, 21),
(26, 27, 22),
(26, 28, 23),
(26, 29, 24),
(26, 30, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 3, MOTORISTA 3
(27, 31, 6),
(27, 32, 7),
(27, 33, 8),
(27, 34, 9),
(27, 35, 10),
(27, 1, 11),
(27, 2, 12),
(27, 3, 13),
(27, 4, 14),
(27, 5, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 3, MOTORISTA 3
(28, 31, 16),
(28, 32, 17),
(28, 33, 18),
(28, 34, 19),
(28, 35, 20),
(28, 1, 21),
(28, 2, 22),
(28, 3, 23),
(28, 4, 24),
(28, 5, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 3, MOTORISTA 3
(29, 6, 6),
(29, 7, 7),
(29, 8, 8),
(29, 9, 9),
(29, 10, 10),
(29, 11, 11),
(29, 12, 12),
(29, 13, 13),
(29, 14, 14),
(29, 15, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 3, MOTORISTA 3
(30, 6, 16),
(30, 7, 17),
(30, 8, 18),
(30, 9, 19),
(30, 10, 20),
(30, 11, 21),
(30, 12, 22),
(30, 13, 23),
(30, 14, 24),
(30, 15, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 3, MOTORISTA 4
(31, 16, 6),
(31, 17, 7),
(31, 18, 8),
(31, 19, 9),
(31, 20, 10),
(31, 21, 11),
(31, 22, 12),
(31, 23, 13),
(31, 24, 14),
(31, 25, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 3, MOTORISTA 4
(32, 16, 16),
(32, 17, 17),
(32, 18, 18),
(32, 19, 19),
(32, 20, 20),
(32, 21, 21),
(32, 22, 22),
(32, 23, 23),
(32, 24, 24),
(32, 25, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 3, MOTORISTA 4
(33, 26, 6),
(33, 27, 7),
(33, 28, 8),
(33, 29, 9),
(33, 30, 10),
(33, 31, 11),
(33, 32, 12),
(33, 33, 13),
(33, 34, 14),
(33, 35, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 3, MOTORISTA 4
(34, 26, 16),
(34, 27, 17),
(34, 28, 18),
(34, 29, 19),
(34, 30, 20),
(34, 31, 21),
(34, 32, 22),
(34, 33, 23),
(34, 34, 24),
(34, 35, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 3, MOTORISTA 4
(35, 1, 6),
(35, 2, 7),
(35, 3, 8),
(35, 4, 9),
(35, 5, 10),
(35, 6, 11),
(35, 7, 12),
(35, 8, 13),
(35, 9, 14),
(35, 10, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 3, MOTORISTA 4
(36, 1, 16),
(36, 2, 17),
(36, 3, 18),
(36, 4, 19),
(36, 5, 20),
(36, 6, 21),
(36, 7, 22),
(36, 8, 23),
(36, 9, 24),
(36, 10, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 3, MOTORISTA 4
(37, 11, 6),
(37, 12, 7),
(37, 13, 8),
(37, 14, 9),
(37, 15, 10),
(37, 16, 11),
(37, 17, 12),
(37, 18, 13),
(37, 19, 14),
(37, 20, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 3, MOTORISTA 4
(38, 11, 16),
(38, 12, 17),
(38, 13, 18),
(38, 14, 19),
(38, 15, 20),
(38, 16, 21),
(38, 17, 22),
(38, 18, 23),
(38, 19, 24),
(38, 20, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 3, MOTORISTA 4
(39, 21, 6),
(39, 22, 7),
(39, 23, 8),
(39, 24, 9),
(39, 25, 10),
(39, 26, 11),
(39, 27, 12),
(39, 28, 13),
(39, 29, 14),
(39, 30, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 3, MOTORISTA 4
(40, 21, 16),
(40, 22, 17),
(40, 23, 18),
(40, 24, 19),
(40, 25, 20),
(40, 26, 21),
(40, 27, 22),
(40, 28, 23),
(40, 29, 24),
(40, 30, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 4, MOTORISTA 4
(41, 1, 6),
(41, 2, 7),
(41, 3, 8),
(41, 4, 9),
(41, 5, 10),
(41, 6, 11),
(41, 7, 12),
(41, 8, 13),
(41, 9, 14),
(41, 10, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 4, MOTORISTA 4
(42, 1, 16),
(42, 2, 17),
(42, 3, 18),
(42, 4, 19),
(42, 5, 20),
(42, 6, 21),
(42, 7, 22),
(42, 8, 23),
(42, 9, 24),
(42, 10, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 4, MOTORISTA 4
(43, 11, 6),
(43, 12, 7),
(43, 13, 8),
(43, 14, 9),
(43, 15, 10),
(43, 16, 11),
(43, 17, 12),
(43, 18, 13),
(43, 19, 14),
(43, 20, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 4, MOTORISTA 4
(44, 11, 16),
(44, 12, 17),
(44, 13, 18),
(44, 14, 19),
(44, 15, 20),
(44, 16, 21),
(44, 17, 22),
(44, 18, 23),
(44, 19, 24),
(44, 20, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 4, MOTORISTA 4
(45, 21, 6),
(45, 22, 7),
(45, 23, 8),
(45, 24, 9),
(45, 25, 10),
(45, 26, 11),
(45, 27, 12),
(45, 28, 13),
(45, 29, 14),
(45, 30, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 4, MOTORISTA 4
(46, 21, 16),
(46, 22, 17),
(46, 23, 18),
(46, 24, 19),
(46, 25, 20),
(46, 26, 21),
(46, 27, 22),
(46, 28, 23),
(46, 29, 24),
(46, 30, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 4, MOTORISTA 4
(47, 31, 6),
(47, 32, 7),
(47, 33, 8),
(47, 34, 9),
(47, 35, 10),
(47, 1, 11),
(47, 2, 12),
(47, 3, 13),
(47, 4, 14),
(47, 5, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 4, MOTORISTA 4
(48, 31, 16),
(48, 32, 17),
(48, 33, 18),
(48, 34, 19),
(48, 35, 20),
(48, 1, 21),
(48, 2, 22),
(48, 3, 23),
(48, 4, 24),
(48, 5, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 4, MOTORISTA 4
(49, 6, 6),
(49, 7, 7),
(49, 8, 8),
(49, 9, 9),
(49, 10, 10),
(49, 11, 11),
(49, 12, 12),
(49, 13, 13),
(49, 14, 14),
(49, 15, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 4, MOTORISTA 4
(50, 6, 16),
(50, 7, 17),
(50, 8, 18),
(50, 9, 19),
(50, 10, 20),
(50, 11, 21),
(50, 12, 22),
(50, 13, 23),
(50, 14, 24),
(50, 15, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 5, MOTORISTA 4
(51, 16, 6),
(51, 17, 7),
(51, 18, 8),
(51, 19, 9),
(51, 20, 10),
(51, 21, 11),
(51, 22, 12),
(51, 23, 13),
(51, 24, 14),
(51, 25, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 5, MOTORISTA 4
(52, 16, 16),
(52, 17, 17),
(52, 18, 18),
(52, 19, 19),
(52, 20, 20),
(52, 21, 21),
(52, 22, 22),
(52, 23, 23),
(52, 24, 24),
(52, 25, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 5, MOTORISTA 4
(53, 26, 6),
(53, 27, 7),
(53, 28, 8),
(53, 29, 9),
(53, 30, 10),
(53, 31, 11),
(53, 32, 12),
(53, 33, 13),
(53, 34, 14),
(53, 35, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 5, MOTORISTA 4
(54, 26, 16),
(54, 27, 17),
(54, 28, 18),
(54, 29, 19),
(54, 30, 20),
(54, 31, 21),
(54, 32, 22),
(54, 33, 23),
(54, 34, 24),
(54, 35, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 5, MOTORISTA 4
(55, 1, 6),
(55, 2, 7),
(55, 3, 8),
(55, 4, 9),
(55, 5, 10),
(55, 6, 11),
(55, 7, 12),
(55, 8, 13),
(55, 9, 14),
(55, 10, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 5, MOTORISTA 4
(56, 1, 16),
(56, 2, 17),
(56, 3, 18),
(56, 4, 19),
(56, 5, 20),
(56, 6, 21),
(56, 7, 22),
(56, 8, 23),
(56, 9, 24),
(56, 10, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 5, MOTORISTA 4
(57, 11, 6),
(57, 12, 7),
(57, 13, 8),
(57, 14, 9),
(57, 15, 10),
(57, 16, 11),
(57, 17, 12),
(57, 18, 13),
(57, 19, 14),
(57, 20, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 5, MOTORISTA 4
(58, 11, 16),
(58, 12, 17),
(58, 13, 18),
(58, 14, 19),
(58, 15, 20),
(58, 16, 21),
(58, 17, 22),
(58, 18, 23),
(58, 19, 24),
(58, 20, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 5, MOTORISTA 4
(59, 21, 6),
(59, 22, 7),
(59, 23, 8),
(59, 24, 9),
(59, 25, 10),
(59, 26, 11),
(59, 27, 12),
(59, 28, 13),
(59, 29, 14),
(59, 30, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 5, MOTORISTA 4
(60, 21, 16),
(60, 22, 17),
(60, 23, 18),
(60, 24, 19),
(60, 25, 20),
(60, 26, 21),
(60, 27, 22),
(60, 28, 23),
(60, 29, 24),
(60, 30, 25),
-- Rota para o trajeto IDA, SEGUNDA, ESCOLA 5, MOTORISTA 5
(61, 1, 6),
(61, 2, 7),
(61, 3, 8),
(61, 4, 9),
(61, 5, 10),
(61, 6, 11),
(61, 7, 12),
(61, 8, 13),
(61, 9, 14),
(61, 10, 15),
-- Rota para o trajeto VOLTA, SEGUNDA, ESCOLA 5, MOTORISTA 5
(62, 1, 16),
(62, 2, 17),
(62, 3, 18),
(62, 4, 19),
(62, 5, 20),
(62, 6, 21),
(62, 7, 22),
(62, 8, 23),
(62, 9, 24),
(62, 10, 25),
-- Rota para o trajeto IDA, TERÇA, ESCOLA 5, MOTORISTA 5
(63, 11, 6),
(63, 12, 7),
(63, 13, 8),
(63, 14, 9),
(63, 15, 10),
(63, 16, 11),
(63, 17, 12),
(63, 18, 13),
(63, 19, 14),
(63, 20, 15),
-- Rota para o trajeto VOLTA, TERÇA, ESCOLA 5, MOTORISTA 5
(64, 11, 16),
(64, 12, 17),
(64, 13, 18),
(64, 14, 19),
(64, 15, 20),
(64, 16, 21),
(64, 17, 22),
(64, 18, 23),
(64, 19, 24),
(64, 20, 25),
-- Rota para o trajeto IDA, QUARTA, ESCOLA 5, MOTORISTA 5
(65, 21, 6),
(65, 22, 7),
(65, 23, 8),
(65, 24, 9),
(65, 25, 10),
(65, 26, 11),
(65, 27, 12),
(65, 28, 13),
(65, 29, 14),
(65, 30, 15),
-- Rota para o trajeto VOLTA, QUARTA, ESCOLA 5, MOTORISTA 5
(66, 21, 16),
(66, 22, 17),
(66, 23, 18),
(66, 24, 19),
(66, 25, 20),
(66, 26, 21),
(66, 27, 22),
(66, 28, 23),
(66, 29, 24),
(66, 30, 25),
-- Rota para o trajeto IDA, QUINTA, ESCOLA 5, MOTORISTA 5
(67, 31, 6),
(67, 32, 7),
(67, 33, 8),
(67, 34, 9),
(67, 35, 10),
(67, 1, 11),
(67, 2, 12),
(67, 3, 13),
(67, 4, 14),
(67, 5, 15),
-- Rota para o trajeto VOLTA, QUINTA, ESCOLA 5, MOTORISTA 5
(68, 31, 16),
(68, 32, 17),
(68, 33, 18),
(68, 34, 19),
(68, 35, 20),
(68, 1, 21),
(68, 2, 22),
(68, 3, 23),
(68, 4, 24),
(68, 5, 25),
-- Rota para o trajeto IDA, SEXTA, ESCOLA 5, MOTORISTA 5
(69, 6, 6),
(69, 7, 7),
(69, 8, 8),
(69, 9, 9),
(69, 10, 10),
(69, 11, 11),
(69, 12, 12),
(69, 13, 13),
(69, 14, 14),
(69, 15, 15),
-- Rota para o trajeto VOLTA, SEXTA, ESCOLA 5, MOTORISTA 5
(70, 6, 16),
(70, 7, 17),
(70, 8, 18),
(70, 9, 19),
(70, 10, 20),
(70, 11, 21),
(70, 12, 22),
(70, 13, 23),
(70, 14, 24),
(70, 15, 25);
-- Inserindo registros na tabela `transporte_escola`
INSERT INTO `transporte_escola` (`transporte_id`, `escola_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

SELECT * FROM usuario; 