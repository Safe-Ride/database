

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
	`nome` VARCHAR(45) NULL,
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
	`nome` VARCHAR(45) NULL DEFAULT NULL,
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
	`nome` VARCHAR(45) NULL,
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

INSERT INTO imagem VALUES(1, 'profile.png')

-- Inserindo registros na tabela `imagem`
INSERT INTO `imagem` (`caminho`) VALUES
('profile.jpg');


-- Inserindo registros na tabela `usuario`
INSERT INTO `usuario` (`nome`, `email`, `senha`, `cpf`, `telefone`, `data_nascimento`, `tipo`, `imagem_id`) VALUES
('Motorista 1', 'motorista1@example.com', 'senha1', '12345678901', '11999999991', '1980-01-01', 1, 1),
('Motorista 2', 'motorista2@example.com', 'senha2', '12345678902', '11999999992', '1981-02-02', 1, 1),
('Motorista 3', 'motorista3@example.com', 'senha3', '12345678903', '11999999993', '1982-03-03', 1, 1),
('Motorista 4', 'motorista4@example.com', 'senha4', '12345678904', '11999999994', '1983-04-04', 1, 1),
('Motorista 5', 'motorista5@example.com', 'senha5', '12345678905', '11999999995', '1984-05-05', 1, 1),
('Responsável 1', 'responsavel1@example.com', 'senha6', '12345678906', '11999999996', '1985-06-06', 2, 1),
('Responsável 2', 'responsavel2@example.com', 'senha7', '12345678907', '11999999997', '1986-07-07', 2, 1),
('Responsável 3', 'responsavel3@example.com', 'senha8', '12345678908', '11999999998', '1987-08-08', 2, 1),
('Responsável 4', 'responsavel4@example.com', 'senha9', '12345678909', '11999999999', '1988-09-09', 2, 1),
('Responsável 5', 'responsavel5@example.com', 'senha10', '12345678910', '11999999900', '1989-10-10', 2, 1),
('Responsável 6', 'responsavel6@example.com', 'senha11', '12345678911', '11999999911', '1990-11-11', 2, 1),
('Responsável 7', 'responsavel7@example.com', 'senha12', '12345678912', '11999999912', '1991-12-12', 2, 1),
('Responsável 8', 'responsavel8@example.com', 'senha13', '12345678913', '11999999913', '1992-01-13', 2, 1),
('Responsável 9', 'responsavel9@example.com', 'senha14', '12345678914', '11999999914', '1993-02-14', 2, 1),
('Responsável 10', 'responsavel10@example.com', 'senha15', '12345678915', '11999999915', '1994-03-15', 2, 1),
('Responsável 11', 'responsavel11@example.com', 'senha16', '12345678916', '11999999916', '1995-04-16', 2, 1),
('Responsável 12', 'responsavel12@example.com', 'senha17', '12345678917', '11999999917', '1996-05-17', 2, 1),
('Responsável 13', 'responsavel13@example.com', 'senha18', '12345678918', '11999999918', '1997-06-18', 2, 1),
('Responsável 14', 'responsavel14@example.com', 'senha19', '12345678919', '11999999919', '1998-07-19', 2, 1),
('Responsável 15', 'responsavel15@example.com', 'senha20', '12345678920', '11999999920', '1999-08-20', 2, 1),
('Responsável 16', 'responsavel16@example.com', 'senha21', '12345678921', '11999999921', '2000-09-21', 2, 1),
('Responsável 17', 'responsavel17@example.com', 'senha22', '12345678922', '11999999922', '2001-10-22', 2, 1),
('Responsável 18', 'responsavel18@example.com', 'senha23', '12345678923', '11999999923', '2002-11-23', 2, 1),
('Responsável 19', 'responsavel19@example.com', 'senha24', '12345678924', '11999999924', '2003-12-24', 2, 1),
('Responsável 20', 'responsavel20@example.com', 'senha25', '12345678925', '11999999925', '2004-01-25', 2, 1),
('Responsável 21', 'responsavel21@example.com', 'senha26', '12345678926', '11999999926', '2005-02-26', 2, 1),
('Responsável 22', 'responsavel22@example.com', 'senha27', '12345678927', '11999999927', '2006-03-27', 2, 1),
('Responsável 23', 'responsavel23@example.com', 'senha28', '12345678928', '11999999928', '2007-04-28', 2, 1),
('Responsável 24', 'responsavel24@example.com', 'senha29', '12345678929', '11999999929', '2008-05-29', 2, 1),
('Responsável 25', 'responsavel25@example.com', 'senha30', '12345678930', '11999999930', '2009-06-30', 2, 1);

-- Inserindo registros na tabela `endereco`
INSERT INTO `endereco` (`latitude`, `longitude`, `cep`, `numero`, `complemento`, `usuario_id`) VALUES
('23.5505', '46.6333', '01001000', 1, 'Apto 1', 6),
('23.5515', '46.6343', '01002000', 2, 'Apto 2', 7),
('23.5525', '46.6353', '01003000', 3, 'Apto 3', 8),
('23.5535', '46.6363', '01004000', 4, 'Apto 4', 9),
('23.5545', '46.6373', '01005000', 5, 'Apto 5', 10),
('23.5555', '46.6383', '01006000', 6, 'Apto 6', 11),
('23.5565', '46.6393', '01007000', 7, 'Apto 7', 12),
('23.5575', '46.6403', '01008000', 8, 'Apto 8', 13),
('23.5585', '46.6413', '01009000', 9, 'Apto 9', 14),
('23.5595', '46.6423', '01010000', 10, 'Apto 10', 15),
('23.5605', '46.6433', '01011000', 11, 'Apto 11', 16),
('23.5615', '46.6443', '01012000', 12, 'Apto 12', 17),
('23.5625', '46.6453', '01013000', 13, 'Apto 13', 18),
('23.5635', '46.6463', '01014000', 14, 'Apto 14', 19),
('23.5645', '46.6473', '01015000', 15, 'Apto 15', 20),
('23.5655', '46.6483', '01016000', 16, 'Apto 16', 21),
('23.5665', '46.6493', '01017000', 17, 'Apto 17', 22),
('23.5675', '46.6503', '01018000', 18, 'Apto 18', 23),
('23.5685', '46.6513', '01019000', 19, 'Apto 19', 24),
('23.5695', '46.6523', '01020000', 20, 'Apto 20', 25),
('23.5705', '46.6533', '01021000', 21, 'Apto 21', 26),
('23.5715', '46.6543', '01022000', 22, 'Apto 22', 27),
('23.5725', '46.6553', '01023000', 23, 'Apto 23', 28),
('23.5735', '46.6563', '01024000', 24, 'Apto 24', 29),
('23.5745', '46.6573', '01025000', 25, 'Apto 25', 30),
('23.5755', '46.6583', '01026000', 1, 'Apto 26', 1),
('23.5765', '46.6593', '01027000', 2, 'Apto 27', 2),
('23.5775', '46.6603', '01028000', 3, 'Apto 28', 3),
('23.5785', '46.6613', '01029000', 4, 'Apto 29', 4),
('23.5795', '46.6623', '01030000', 5, 'Apto 30', 5);

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
('Dependente 26', '2012-02-02', '6ª série', 1, 6, 1, 1),
('Dependente 27', '2012-03-03', '6ª série', 2, 7, 2, 1),
('Dependente 28', '2012-04-04', '6ª série', 3, 8, 3, 1),
('Dependente 29', '2012-05-05', '6ª série', 4, 9, 4, 1),
('Dependente 30', '2012-06-06', '6ª série', 5, 10, 5, 1);

-- Inserindo registros na tabela `transporte`
INSERT INTO `transporte` (`placa`, `cnpj`, `cnh`, `crm`, `crmc`, `usuario_id`) VALUES
('ABC1234', '12345678000100', '123456789', '1234567', '12345678901234', 1),
('DEF5678', '23456789000111', '234567890', '2345678', '23456789012345', 2),
('GHI9012', '34567890000122', '345678901', '3456789', '34567890123456', 3),
('JKL3456', '45678901000133', '456789012', '4567890', '45678901234567', 4),
('MNO7890', '56789012000144', '567890123', '5678901', '56789012345678', 5);

-- Inserindo registros na tabela `trajeto`
INSERT INTO `trajeto` (`tipo`, `dia_semana`, `escola_id`, `motorista_id`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(1, 3, 3, 3),
(2, 4, 4, 4),
(1, 5, 5, 5),
(2, 1, 1, 1),
(1, 2, 2, 2),
(2, 3, 3, 3),
(1, 4, 4, 4),
(2, 5, 5, 5),
(1, 1, 1, 1),
(2, 2, 2, 2),
(1, 3, 3, 3),
(2, 4, 4, 4),
(1, 5, 5, 5),
(2, 1, 1, 1),
(1, 2, 2, 2),
(2, 3, 3, 3),
(1, 4, 4, 4),
(2, 5, 5, 5);

-- Inserindo registros na tabela `rota`
INSERT INTO `rota` (`trajeto_id`, `dependente_id`, `endereco_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);

-- Inserindo registros na tabela `transporte_escola`
INSERT INTO `transporte_escola` (`transporte_id`, `escola_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
