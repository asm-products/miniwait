

-- -----------------------------------------------------
-- Table category
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS category (
  id SERIAL NOT NULL ,
  description VARCHAR(80) NOT NULL  ,
  PRIMARY KEY (id) )
;


-- -----------------------------------------------------
-- Table company
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS company (
  id SERIAL PRIMARY KEY ,
  category_id INT NOT NULL ,
  name VARCHAR(80) NOT NULL  ,
  CONSTRAINT fk_company_category
    FOREIGN KEY (category_id )
    REFERENCES category (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table location
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS location (
  id SERIAL PRIMARY KEY  ,
  company_id INT NOT NULL ,
  street1 VARCHAR(45) NOT NULL ,
  street2 VARCHAR(45) NULL ,
  city VARCHAR(45) NULL ,
  state_province VARCHAR(45) NULL ,
  postal_code VARCHAR(10) NULL ,
  country VARCHAR(45) NULL ,
  phone_number VARCHAR(12) NULL ,
  CONSTRAINT fk_location_company1
    FOREIGN KEY (company_id )
    REFERENCES company (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table service
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS service (
  id SERIAL PRIMARY KEY  ,
  company_id INT NOT NULL ,
  is_primary BIT NULL ,
  CONSTRAINT fk_service_company1
    FOREIGN KEY (company_id )
    REFERENCES company (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table person
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS person (
  id SERIAL PRIMARY KEY  ,
  username VARCHAR(45) NOT NULL ,
  email_address VARCHAR(90) NOT NULL ,
  first_name VARCHAR(20) NOT NULL ,
  last_name VARCHAR(30) NOT NULL ,
  street1 VARCHAR(45) NULL ,
  street2 VARCHAR(45) NULL ,
  city VARCHAR(45) NULL ,
  state_province VARCHAR(45) NULL,
  postal_code VARCHAR(10) NULL ,
  country VARCHAR(45) NULL ,
  phone_number VARCHAR(12) NULL ,
  password VARCHAR(100) NOT NULL )
;


-- -----------------------------------------------------
-- Table favorite
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS favorite (
  location_id INT NOT NULL ,
  person_id INT NOT NULL ,
  PRIMARY KEY (location_id, person_id) ,
  CONSTRAINT fk_location_has_consumer_location1
    FOREIGN KEY (location_id )
    REFERENCES location (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_favorite_person1
    FOREIGN KEY (person_id )
    REFERENCES person (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table service_location
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS service_location (
  id SERIAL PRIMARY KEY ,
  location_id INT NOT NULL ,
  service_id INT NOT NULL ,
  is_available_here BOOLEAN NOT NULL DEFAULT true ,
  wait_time INT NOT NULL ,
  wait_time_updated TIMESTAMP NULL ,
  CONSTRAINT fk_location_has_service_location1
    FOREIGN KEY (location_id )
    REFERENCES location (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_location_has_service_service1
    FOREIGN KEY (service_id )
    REFERENCES service (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table service_watch
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS service_watch (
  service_location_id INT NOT NULL ,
  person_id INT NOT NULL ,
  PRIMARY KEY (service_location_id, person_id) ,
  CONSTRAINT fk_service_watch_service_location1
    FOREIGN KEY (service_location_id )
    REFERENCES service_location (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_service_watch_person1
    FOREIGN KEY (person_id )
    REFERENCES person (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table company_contact
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS company_contact (
  company_id INT NOT NULL ,
  person_id INT NOT NULL ,
  is_primary BOOLEAN NULL DEFAULT false,
  PRIMARY KEY (company_id, person_id) ,
  CONSTRAINT fk_company_has_person_company1
    FOREIGN KEY (company_id )
    REFERENCES company (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_company_has_person_person1
    FOREIGN KEY (person_id )
    REFERENCES person (id )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

