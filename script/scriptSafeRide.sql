CREATE USER IF NOT EXISTS 'safeuser'@'localhost' IDENTIFIED BY 'eunaosei';
GRANT ALL PRIVILEGES ON saferide.* TO 'safeuser'@'localhost';
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS saferide;
CREATE DATABASE saferide;
use saferide;

-- -----------------------------------------------------
-- Table `usuario`
-- -----------------------------------------------------
CREATE TABLE `usuario` (
	`id` INT auto_increment,
	`nome` VARCHAR(45) NULL,
	`email` VARCHAR(45) NULL,
	`senha` CHAR(64) NULL,
	`cpf` CHAR(11) NULL,
	`telefone` CHAR(11) NULL,
	`data_nascimento` DATE NULL,
	`tipo` INT NULL,
	PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table `dependente`
-- -----------------------------------------------------
CREATE TABLE `dependente` (
	`id` INT NOT NULL,
	`nome` VARCHAR(45) NULL,
	`data_nascimento` DATE NULL,
	`escola` VARCHAR(45) NULL,
	`serie` VARCHAR(45) NULL,
	`responsavel_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_dependente_usuario_idx` (`responsavel_id` ASC) VISIBLE,
	CONSTRAINT `fk_dependente_usuario`
		FOREIGN KEY (`responsavel_id`)
		REFERENCES `Usuario` (`id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);
    
-- -----------------------------------------------------
-- Table `transporte`
-- -----------------------------------------------------
CREATE TABLE `transporte` (
	`id` INT NOT NULL,
	`placa` VARCHAR(45) NULL DEFAULT NULL,
	`cnpj` CHAR(14) NULL DEFAULT NULL,
	`cnh` CHAR(9) NULL DEFAULT NULL,
	`crm` VARCHAR(15) NULL DEFAULT NULL,
	`crmc` VARCHAR(20) NULL DEFAULT NULL,
	`motorista_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_transporte_usuario_idx` (`motorista_id` ASC) VISIBLE,
	CONSTRAINT `fk_transporte_usuario`
		FOREIGN KEY (`motorista_id`)
		REFERENCES `usuario` (`id`)
);

-- -----------------------------------------------------
-- Table `endereco`
-- -----------------------------------------------------
CREATE TABLE `endereco` (
	`id` INT NOT NULL,
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
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_escola_endereco_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_escola_endereco`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `endereco` (`id`));

-- -----------------------------------------------------
-- Table `trajeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trajeto` (
	`id` INT NOT NULL,
	`tipo` VARCHAR(45) NULL DEFAULT NULL,
	`dia_semana` VARCHAR(45) NULL DEFAULT NULL,
	`escola_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_trajeto_escola_idx` (`escola_id` ASC) VISIBLE,
	CONSTRAINT `fk_trajeto_escola`
		FOREIGN KEY (`escola_id`)
		REFERENCES `escola` (`id`)
);

-- -----------------------------------------------------
-- Table `rota`
-- -----------------------------------------------------
CREATE TABLE `rota` (
  `trajeto_id` INT NOT NULL,
  `dependente_id` INT NOT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`trajeto_id`, `dependente_id`, `endereco_id`),
  INDEX `fk_rota_trajeto_idx` (`dependente_id` ASC) VISIBLE,
  INDEX `fk_rota_dependente_idx` (`trajeto_id` ASC) VISIBLE,
  INDEX `fk_rota_endereco_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_rota_dependente`
    FOREIGN KEY (`dependente_id`)
    REFERENCES `dependente` (`id`),
  CONSTRAINT `fk_rota_trajeto`
    FOREIGN KEY (`trajeto_id`)
    REFERENCES `trajeto` (`id`),
  CONSTRAINT `fk_rota_endereco`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `endereco` (`id`));

    
-- -----------------------------------------------------
-- Table `chat`
-- -----------------------------------------------------
CREATE TABLE `chat` (
	`id` INT NOT NULL,
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
	`id` INT NOT NULL,
	`data` DATETIME NULL,
	`conteudo` VARCHAR(45) NULL,
	`chat_id` INT NOT NULL,
	`usuario_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_mensagem_chat_idx` (`chat_id` ASC) VISIBLE,
	INDEX `fk_mensagem_usuario_idc` (`usuario_id` ASC) VISIBLE,
	CONSTRAINT `fk_mensagem_chat`
		FOREIGN KEY (`chat_id`)
		REFERENCES `chat` (`id`),
	CONSTRAINT `fk_mensagem_usuario`
		FOREIGN KEY (`usuario_id`)
		REFERENCES `usuario` (`id`)
);