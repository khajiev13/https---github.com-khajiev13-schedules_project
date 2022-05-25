-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema activities_schedule
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema activities_schedule
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `activities_schedule` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `activities_schedule` ;

-- -----------------------------------------------------
-- Table `activities_schedule`.`activity_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`activity_types` (
  `activity_type_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  `max_num_participants` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`activity_type_id`),
  UNIQUE INDEX `activity_type_id` (`activity_type_id` ASC) VISIBLE,
  UNIQUE INDEX `type_UNIQUE` (`type` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`locations` (
  `loc_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `loc_name` VARCHAR(20) NULL DEFAULT NULL,
  `located_campus` VARCHAR(55) NULL DEFAULT NULL,
  PRIMARY KEY (`loc_id`),
  UNIQUE INDEX `loc_name_UNIQUE` (`loc_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`location_pins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`location_pins` (
  `activity_type_id` TINYINT UNSIGNED NOT NULL,
  `loc_id` TINYINT UNSIGNED NOT NULL,
  INDEX `activity_type_id` (`activity_type_id` ASC) VISIBLE,
  INDEX `loc_id` (`loc_id` ASC) VISIBLE,
  CONSTRAINT `location_pins_ibfk_1`
    FOREIGN KEY (`activity_type_id`)
    REFERENCES `activities_schedule`.`activity_types` (`activity_type_id`),
  CONSTRAINT `location_pins_ibfk_2`
    FOREIGN KEY (`loc_id`)
    REFERENCES `activities_schedule`.`locations` (`loc_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`referees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`referees` (
  `referee_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `activity_type_id` TINYINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(20) NULL DEFAULT NULL,
  `last_name` VARCHAR(20) NULL DEFAULT NULL,
  `experience_year` VARCHAR(3) NULL DEFAULT NULL,
  `uniform_color` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`referee_id`),
  UNIQUE INDEX `referee_id` (`referee_id` ASC) VISIBLE,
  INDEX `activity_type_id` (`activity_type_id` ASC) VISIBLE,
  CONSTRAINT `referees_ibfk_1`
    FOREIGN KEY (`activity_type_id`)
    REFERENCES `activities_schedule`.`activity_types` (`activity_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`students` (
  `student_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `nickname` VARCHAR(20) NOT NULL,
  `birth` DATETIME NULL DEFAULT NULL,
  `school_year` VARCHAR(20) NULL DEFAULT NULL,
  `major` VARCHAR(50) NULL DEFAULT NULL,
  `regist_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `degree` VARCHAR(20) NULL DEFAULT NULL,
  `team_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `player_id` VARCHAR(3) NULL DEFAULT NULL,
  `school_student_id` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE INDEX `student_id` (`student_id` ASC) VISIBLE,
  UNIQUE INDEX `school_student_id_UNIQUE` (`school_student_id` ASC) VISIBLE,
  INDEX `team_id` (`team_id` ASC) VISIBLE,
  CONSTRAINT `students_ibfk_1`
    FOREIGN KEY (`team_id`)
    REFERENCES `activities_schedule`.`teams` (`team_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`teams` (
  `team_id` SMALLINT UNSIGNED NOT NULL,
  `activity_type_id` TINYINT UNSIGNED NOT NULL,
  `uniform_colors` JSON NULL DEFAULT NULL,
  `team_name` VARCHAR(20) NULL DEFAULT NULL,
  `team_captain_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE INDEX `team_id` (`team_id` ASC) VISIBLE,
  UNIQUE INDEX `team_name_UNIQUE` (`team_name` ASC) VISIBLE,
  INDEX `fk_teams_activity_types1_idx` (`activity_type_id` ASC) VISIBLE,
  INDEX `fk_teams_students1_idx` (`team_captain_id` ASC) VISIBLE,
  CONSTRAINT `fk_teams_activity_types1`
    FOREIGN KEY (`activity_type_id`)
    REFERENCES `activities_schedule`.`activity_types` (`activity_type_id`),
  CONSTRAINT `fk_teams_students1`
    FOREIGN KEY (`team_captain_id`)
    REFERENCES `activities_schedule`.`students` (`student_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `activities_schedule`.`schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activities_schedule`.`schedules` (
  `schedule_id` VARCHAR(5) NOT NULL,
  `activity_type_id` TINYINT UNSIGNED NOT NULL,
  `team_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `referee_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `date` DATETIME NULL DEFAULT NULL,
  `loc_id` TINYINT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  INDEX `team_id` (`team_id` ASC) VISIBLE,
  INDEX `activity_type_id` (`activity_type_id` ASC) VISIBLE,
  INDEX `referee_id` (`referee_id` ASC) VISIBLE,
  INDEX `loc_id` (`loc_id` ASC) VISIBLE,
  CONSTRAINT `schedules_ibfk_1`
    FOREIGN KEY (`team_id`)
    REFERENCES `activities_schedule`.`teams` (`team_id`)
    ON DELETE SET NULL,
  CONSTRAINT `schedules_ibfk_2`
    FOREIGN KEY (`activity_type_id`)
    REFERENCES `activities_schedule`.`activity_types` (`activity_type_id`),
  CONSTRAINT `schedules_ibfk_3`
    FOREIGN KEY (`referee_id`)
    REFERENCES `activities_schedule`.`referees` (`referee_id`),
  CONSTRAINT `schedules_ibfk_4`
    FOREIGN KEY (`loc_id`)
    REFERENCES `activities_schedule`.`locations` (`loc_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
