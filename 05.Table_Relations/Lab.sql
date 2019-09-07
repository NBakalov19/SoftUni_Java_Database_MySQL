/*Task 1*/
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
`mountain_id` INT,
CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains`(`id`)
);

/*Task 2*/


/*Task 3*/
SELECT 
	r.`starting_point` AS 'route_starting_point',
    r.`end_point` AS 'route_ending_point' ,
    r.`leader_id`,
    concat(c.`first_name`, ' ' , c.`last_name`) AS 'leader_name'
FROM `campers` AS c
JOIN  `routes` AS r
ON r.`leader_id` = c.`id`;
