-- CREATE USER IF NOT EXISTS 'safeuser'@'localhost' IDENTIFIED BY 'eunaosei';
-- GRANT ALL PRIVILEGES ON saferide.* TO 'safeuser'@'localhost';
-- FLUSH PRIVILEGES;
-- select * from mysql.user;
 drop database if exists saferide;
-- select  * from usuario;
CREATE DATABASE IF NOT EXISTS saferide;
use saferide;
-- delete from usuario where id< 7;
-- -----------------------------------------------------
-- Table `Transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transacao` (
  `id` INT NOT NULL,
  `valor` DECIMAL(5,2) NULL,
  `dia` DATETIME NULL,
  `contaDebito` VARCHAR(20) NULL,
  `contaDeposito` VARCHAR(20) NULL,
  `fkDebito` INT NOT NULL,
  `fkDeposito` INT NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT auto_increment ,
  `nome` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `senha` CHAR(64) NULL,
  `CPF` CHAR(11) NULL,
  `telefone` CHAR(11) NULL,
  `data_nascimento` DATE NULL,
  `tipo` INT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Dependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Dependente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `data_nascimento` DATE NULL,
  `escola` VARCHAR(45) NULL,
  `serie` VARCHAR(45) NULL,
  `responsavel_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Dependente_Cliente1_idx` (`responsavel_id` ASC) VISIBLE,
  CONSTRAINT `fk_Dependente_Cliente1`
    FOREIGN KEY (`responsavel_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Transporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transporte` (
  `id` INT NOT NULL,
  `placa` VARCHAR(45) NULL,
  `cnpj` CHAR(14) NULL,
  `cnh` CHAR(9) NULL,
  `crm` VARCHAR(15) NULL,
  `crmc` VARCHAR(20) NULL,
  `motorista_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Transporte_Cliente_idx` (`motorista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Transporte_Cliente`
    FOREIGN KEY (`motorista_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Endereco` (
  `id` INT NOT NULL,
  `latitude` VARCHAR(45) NULL,
  `longitude` VARCHAR(45) NULL,
  `cep` CHAR(8) NULL,
  `numero` DECIMAL(4) NULL,
  `complemento` VARCHAR(45) NULL,
  `usuario_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Endereco_Usuario1_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_Endereco_Usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Trajeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Trajeto` (
  `id` INT NOT NULL,
  `escola` VARCHAR(45) NULL,
  `tipo` VARCHAR(45) NULL,
  `diaSemana` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Chat` (
  `id` INT NOT NULL,
  `responsavel_id` INT NOT NULL,
  `motorista_id` INT NOT NULL,
  PRIMARY KEY (`id`, `motorista_id`, `responsavel_id`),
  INDEX `fk_Chat_Cliente1_idx` (`responsavel_id` ASC) VISIBLE,
  INDEX `fk_Chat_Cliente2_idx` (`motorista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Chat_Cliente1`
    FOREIGN KEY (`responsavel_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Chat_Cliente2`
    FOREIGN KEY (`motorista_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Mensagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mensagem` (
  `id` INT NOT NULL,
  `data` DATETIME NULL,
  `conteudo` VARCHAR(45) NULL,
  `chat_id` INT NOT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Mensagem_Chat1_idx` (`chat_id` ASC) VISIBLE,
  INDEX `fk_Mensagem_Cliente1_idx` (`cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Mensagem_Chat1`
    FOREIGN KEY (`chat_id`)
    REFERENCES `Chat` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Mensagem_Cliente1`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `Usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `TrajetoDependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TrajetoDependente` (
  `trajeto_id` INT NOT NULL,
  `dependente_id` INT NOT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`trajeto_id`, `dependente_id`, `endereco_id`),
  INDEX `fk_Trajeto_has_Dependente_Dependente1_idx` (`dependente_id` ASC) VISIBLE,
  INDEX `fk_Trajeto_has_Dependente_Trajeto1_idx` (`trajeto_id` ASC) VISIBLE,
  INDEX `fk_TrajetoDependente_Endereco1_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_Trajeto_has_Dependente_Trajeto1`
    FOREIGN KEY (`trajeto_id`)
    REFERENCES `Trajeto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trajeto_has_Dependente_Dependente1`
    FOREIGN KEY (`dependente_id`)
    REFERENCES `Dependente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TrajetoDependente_Endereco1`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `Endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `endereco` (
  `id` INT NOT NULL,
  `latitude` VARCHAR(45) NULL DEFAULT NULL,
  `longitude` VARCHAR(45) NULL DEFAULT NULL,
  `cep` CHAR(8) NULL DEFAULT NULL,
  `numero` DECIMAL(4,0) NULL DEFAULT NULL,
  `complemento` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `senha` CHAR(16) NULL DEFAULT NULL,
  `CPF` CHAR(11) NULL DEFAULT NULL,
  `telefone` CHAR(11) NULL DEFAULT NULL,
  `dataNascimento` DATE NULL DEFAULT NULL,
  `tipo` INT NULL DEFAULT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Cliente_Endereco1_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Endereco1`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `endereco` (`id`));


-- -----------------------------------------------------
-- Table `chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chat` (
  `id` INT NOT NULL,
  `responsavel_id` INT NOT NULL,
  `motorista_id` INT NOT NULL,
  PRIMARY KEY (`id`, `motorista_id`, `responsavel_id`),
  INDEX `fk_Chat_Cliente1_idx` (`responsavel_id` ASC) VISIBLE,
  INDEX `fk_Chat_Cliente2_idx` (`motorista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Chat_Cliente1`
    FOREIGN KEY (`responsavel_id`)
    REFERENCES `cliente` (`id`),
  CONSTRAINT `fk_Chat_Cliente2`
    FOREIGN KEY (`motorista_id`)
    REFERENCES `cliente` (`id`));


-- -----------------------------------------------------
-- Table `dependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dependente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `data_nascimento` DATE NULL DEFAULT NULL,
  `escola` VARCHAR(45) NULL DEFAULT NULL,
  `serie` VARCHAR(45) NULL DEFAULT NULL,
  `responsavel_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Dependente_Cliente1_idx` (`responsavel_id` ASC) VISIBLE,
  CONSTRAINT `fk_Dependente_Cliente1`
    FOREIGN KEY (`responsavel_id`)
    REFERENCES `cliente` (`id`));


-- -----------------------------------------------------
-- Table `mensagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mensagem` (
  `id` INT NOT NULL,
  `data` DATETIME NULL DEFAULT NULL,
  `conteudo` VARCHAR(45) NULL DEFAULT NULL,
  `chat_id` INT NOT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Mensagem_Chat1_idx` (`chat_id` ASC) VISIBLE,
  INDEX `fk_Mensagem_Cliente1_idx` (`cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Mensagem_Chat1`
    FOREIGN KEY (`chat_id`)
    REFERENCES `chat` (`id`),
  CONSTRAINT `fk_Mensagem_Cliente1`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `cliente` (`id`));


-- -----------------------------------------------------
-- Table `trajeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trajeto` (
  `id` INT NOT NULL,
  `escola` VARCHAR(45) NULL DEFAULT NULL,
  `tipo` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`));

-- -----------------------------------------------------
-- Table `trajetodependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trajetodependente` (
  `trajeto_id` INT NOT NULL,
  `dependente_id` INT NOT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`trajeto_id`, `dependente_id`, `endereco_id`),
  INDEX `fk_Trajeto_has_Dependente_Dependente1_idx` (`dependente_id` ASC) VISIBLE,
  INDEX `fk_Trajeto_has_Dependente_Trajeto1_idx` (`trajeto_id` ASC) VISIBLE,
  INDEX `fk_TrajetoDependente_Endereco1_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_Trajeto_has_Dependente_Dependente1`
    FOREIGN KEY (`dependente_id`)
    REFERENCES `dependente` (`id`),
  CONSTRAINT `fk_Trajeto_has_Dependente_Trajeto1`
    FOREIGN KEY (`trajeto_id`)
    REFERENCES `trajeto` (`id`),
  CONSTRAINT `fk_TrajetoDependente_Endereco1`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `endereco` (`id`));


-- -----------------------------------------------------
-- Table `transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `transacao` (
  `id` INT NOT NULL,
  `valor` DECIMAL(5,2) NULL DEFAULT NULL,
  `dia` DATETIME NULL DEFAULT NULL,
  `contaDebito` VARCHAR(20) NULL DEFAULT NULL,
  `contaDeposito` VARCHAR(20) NULL DEFAULT NULL,
  `fkDebito` INT NOT NULL,
  `fkDeposito` INT NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `transporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `transporte` (
  `id` INT NOT NULL,
  `placa` VARCHAR(45) NULL DEFAULT NULL,
  `cnpj` CHAR(14) NULL DEFAULT NULL,
  `cnh` CHAR(9) NULL DEFAULT NULL,
  `crm` VARCHAR(15) NULL DEFAULT NULL,
  `crmc` VARCHAR(20) NULL DEFAULT NULL,
  `motorista_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Transporte_Cliente_idx` (`motorista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Transporte_Cliente`
    FOREIGN KEY (`motorista_id`)
    REFERENCES `cliente` (`id`));