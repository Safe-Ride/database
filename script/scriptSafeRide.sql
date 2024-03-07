create database saferide;
use saferide;


-- -----------------------------------------------------
-- Table `mydb`.`Localizacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Localizacao` (
  `idLocalizacao` INT NOT NULL,
  `cep` CHAR(8) NULL,
  `UF` VARCHAR(45) NULL,
  `localidade` VARCHAR(45) NULL,
  `logradouro` VARCHAR(45) NULL,
  `numero` DECIMAL(4) NULL,
  `bairro` VARCHAR(45) NULL,
  `complemento` VARCHAR(45) NULL,
  PRIMARY KEY (`idLocalizacao`));

-- -----------------------------------------------------
-- Table `mydb`.`Motorista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Motorista` (
  `idMotorista` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `CNPJ` CHAR(14) NULL,
  `celular` CHAR(11) NULL,
  `CNH` CHAR(9) NULL,
  `email` VARCHAR(200) NULL,
  `dataNascimento` DATE NULL,
  `senha` CHAR(64) NULL,
  `CRM` VARCHAR(15) NULL,
  `CRMC` VARCHAR(20) NULL,
  `contaDeposito` VARCHAR(20) NULL,
  `fkLocalizacao` INT NOT NULL,
  PRIMARY KEY (`idMotorista`),
  INDEX `fk_Motorista_Localizacao1_idx` (`fkLocalizacao` ASC) VISIBLE,
  CONSTRAINT `fk_Motorista_Localizacao1`
    FOREIGN KEY (`fkLocalizacao`)
    REFERENCES `Localizacao` (`idLocalizacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Responsavel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Responsavel` (
  `idResponsavel` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `dataNascimento` DATE NULL,
  `CPF` CHAR(11) NULL,
  `celular` CHAR(11) NULL,
  `email` VARCHAR(45) NULL,
  `senha` CHAR(64) NULL,
  `contaDebito` VARCHAR(20) NULL,
  `fkMotorista` INT NOT NULL,
  `fkLocalizacao` INT NOT NULL,
  PRIMARY KEY (`idResponsavel`),
  INDEX `fk_Responsavel_Motorista1_idx` (`fkMotorista` ASC) VISIBLE,
  INDEX `fk_Responsavel_Localizacao1_idx` (`fkLocalizacao` ASC) VISIBLE,
  CONSTRAINT `fk_Responsavel_Motorista1`
    FOREIGN KEY (`fkMotorista`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Responsavel_Localizacao1`
    FOREIGN KEY (`fkLocalizacao`)
    REFERENCES `Localizacao` (`idLocalizacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transacao` (
  `idPagamento` INT NOT NULL,
  `valor` DECIMAL(5,2) NULL,
  `dia` DATETIME NULL,
  `contaDebito` VARCHAR(20) NULL,
  `contaDeposito` VARCHAR(20) NULL,
  `fkDebito` INT NOT NULL,
  `fkDeposito` INT NOT NULL,
  PRIMARY KEY (`idPagamento`),
  INDEX `fk_Transacao_Responsavel1_idx` (`fkDebito` ASC) VISIBLE,
  INDEX `fk_Transacao_Motorista1_idx` (`fkDeposito` ASC) VISIBLE,
  CONSTRAINT `fk_Transacao_Responsavel1`
    FOREIGN KEY (`fkDebito`)
    REFERENCES `Responsavel` (`idResponsavel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transacao_Motorista1`
    FOREIGN KEY (`fkDeposito`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Dependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Dependente` (
  `idDependente` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `dataNascimento` DATE NULL,
  `serie` VARCHAR(8) NULL,
  `escola` VARCHAR(45) NULL,
  `fkResponsavel` INT NOT NULL,
  PRIMARY KEY (`idDependente`),
  INDEX `fk_Dependente_Responsavel1_idx` (`fkResponsavel` ASC) VISIBLE,
  CONSTRAINT `fk_Dependente_Responsavel1`
    FOREIGN KEY (`fkResponsavel`)
    REFERENCES `Responsavel` (`idResponsavel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Veiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculo` (
  `idVeiculo` INT NOT NULL,
  `placa` VARCHAR(45) NULL,
  `turno` TINYINT NULL,
  `tipo` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `ano` YEAR NULL,
  `marca` VARCHAR(45) NULL,
  `fkMotorista` INT NOT NULL,
  PRIMARY KEY (`idVeiculo`),
  INDEX `fk_Veiculo_Motorista_idx` (`fkMotorista` ASC) VISIBLE,
  CONSTRAINT `fk_Veiculo_Motorista`
    FOREIGN KEY (`fkMotorista`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


select * from localizacao;
select * from motorista;
select * from responsavel;
select * from dependente;
select * from transacao;
select * from veiculo;