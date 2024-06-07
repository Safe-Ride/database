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