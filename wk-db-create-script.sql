

-- -----------------------------------------------------
-- Table `category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `category` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `description` VARCHAR(80) NOT NULL COMMENT 'description of category; Ex: Automotive' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `company`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `company` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `category_id` INT NOT NULL ,
  `name` VARCHAR(80) NOT NULL COMMENT 'name of the commercial enterprise (not location)	' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_company_category_idx` (`category_id` ASC) ,
  CONSTRAINT `fk_company_category`
    FOREIGN KEY (`category_id` )
    REFERENCES `category` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `location`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `location` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `company_id` INT NOT NULL ,
  `loc_name` VARCHAR(45) NOT NULL,
  `street1` VARCHAR(45) NOT NULL ,
  `street2` VARCHAR(45) NULL ,
  `city` VARCHAR(45) NULL ,
  `state_province` VARCHAR(45) NULL ,
  `postal_code` VARCHAR(10) NULL ,
  `country` VARCHAR(45) NULL ,
  `phone_number` VARCHAR(12) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_location_company1_idx` (`company_id` ASC) ,
  CONSTRAINT `fk_location_company1`
    FOREIGN KEY (`company_id` )
    REFERENCES `company` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `service`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `service` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `company_id` INT NOT NULL ,
  `is_primary` BIT NULL COMMENT 'used in company listings' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_service_company1_idx` (`company_id` ASC) ,
  CONSTRAINT `fk_service_company1`
    FOREIGN KEY (`company_id` )
    REFERENCES `company` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `person`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `person` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'A person can be both a consumer and a company contact.' ,
  `username` VARCHAR(45) NOT NULL COMMENT 'must be system unique	' ,
  `email_address` VARCHAR(90) NOT NULL COMMENT 'must be system unique; simple validation (xxx@yyy.zzz)' ,
  `first_name` VARCHAR(20) NOT NULL ,
  `last_name` VARCHAR(30) NOT NULL ,
  `street1` VARCHAR(45) NULL ,
  `street2` VARCHAR(45) NULL ,
  `city` VARCHAR(45) NULL ,
  `state_province` VARCHAR(45) NULL COMMENT 'Two-characters for USA' ,
  `postal_code` VARCHAR(10) NULL ,
  `country` VARCHAR(45) NULL ,
  `phone_number` VARCHAR(12) NULL ,
  `password` VARCHAR(100) NOT NULL COMMENT 'one-way encryption; never displayed; cannot be recovered; no rules about reusing previous passwords; minimum length: 5 characters; any visible keyboard character allowed except quotation marks and slashes' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `favorite`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `favorite` (
  `location_id` INT NOT NULL ,
  `person_id` INT NOT NULL ,
  PRIMARY KEY (`location_id`, `person_id`) ,
  INDEX `fk_location_has_consumer_location1_idx` (`location_id` ASC) ,
  INDEX `fk_favorite_person1_idx` (`person_id` ASC) ,
  CONSTRAINT `fk_location_has_consumer_location1`
    FOREIGN KEY (`location_id` )
    REFERENCES `location` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorite_person1`
    FOREIGN KEY (`person_id` )
    REFERENCES `person` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `service_location`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `service_location` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `location_id` INT NOT NULL ,
  `service_id` INT NOT NULL ,
  `is_available_here` BIT NOT NULL DEFAULT true ,
  `wait_time` INT NOT NULL COMMENT 'wait time in minutes' ,
  `wait_time_updated` DATETIME NULL ,
  PRIMARY KEY (`id`, `service_id`) ,
  INDEX `fk_location_has_service_service1_idx` (`service_id` ASC) ,
  INDEX `fk_location_has_service_location1_idx` (`location_id` ASC) ,
  CONSTRAINT `fk_location_has_service_location1`
    FOREIGN KEY (`location_id` )
    REFERENCES `location` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_location_has_service_service1`
    FOREIGN KEY (`service_id` )
    REFERENCES `service` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `service_watch`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `service_watch` (
  `service_location_id` INT NOT NULL ,
  `person_id` INT NOT NULL ,
  PRIMARY KEY (`service_location_id`, `person_id`) ,
  INDEX `fk_service_watch_service_location1_idx` (`service_location_id` ASC) ,
  INDEX `fk_service_watch_person1_idx` (`person_id` ASC) ,
  CONSTRAINT `fk_service_watch_service_location1`
    FOREIGN KEY (`service_location_id` )
    REFERENCES `service_location` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_service_watch_person1`
    FOREIGN KEY (`person_id` )
    REFERENCES `person` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `company_contact`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `company_contact` (
  `company_id` INT NOT NULL ,
  `person_id` INT NOT NULL ,
  `is_primary` BIT NULL ,
  PRIMARY KEY (`company_id`, `person_id`) ,
  INDEX `fk_company_has_person_person1_idx` (`person_id` ASC) ,
  INDEX `fk_company_has_person_company1_idx` (`company_id` ASC) ,
  CONSTRAINT `fk_company_has_person_company1`
    FOREIGN KEY (`company_id` )
    REFERENCES `company` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_company_has_person_person1`
    FOREIGN KEY (`person_id` )
    REFERENCES `person` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

