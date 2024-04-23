CREATE USER IF NOT EXISTS 'safeuser'@'localhost' IDENTIFIED BY 'eunaosei';
GRANT ALL PRIVILEGES ON saferide.* TO 'safeuser'@'localhost';
FLUSH PRIVILEGES;

create database saferide;
use saferide;
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
  PRIMARY KEY (`id`))



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
  PRIMARY KEY (`id`))



-- -----------------------------------------------------
-- Table `Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `senha` CHAR(16) NULL,
  `CPF` CHAR(11) NULL,
  `telefone` CHAR(11) NULL,
  `dataNascimento` DATE NULL,
  `tipo` INT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Cliente_Endereco1_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Endereco1`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `Endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



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
    REFERENCES `Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



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
    REFERENCES `Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table `Trajeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Trajeto` (
  `id` INT NOT NULL,
  `escola` VARCHAR(45) NULL,
  `tipo` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))



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
    REFERENCES `Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Chat_Cliente2`
    FOREIGN KEY (`motorista_id`)
    REFERENCES `Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



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
    REFERENCES `Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



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
    ON UPDATE NO ACTION)