-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.35-0ubuntu0.13.10.2 - (Ubuntu)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             8.2.0.4675
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table new_gps_dev.desires
DROP TABLE IF EXISTS `desires`;
CREATE TABLE IF NOT EXISTS `desires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pointer_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `stat` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table new_gps_dev.desires: ~2 rows (approximately)
DELETE FROM `desires`;
/*!40000 ALTER TABLE `desires` DISABLE KEYS */;
INSERT INTO `desires` (`id`, `pointer_id`, `user_id`, `stat`, `created_at`, `updated_at`) VALUES
	(1, 82, 2, 0, '2014-02-02 23:26:07', '2014-02-02 23:26:07'),
	(2, 2, 2, 1, '2014-02-02 23:26:14', '2014-02-02 23:26:14');
/*!40000 ALTER TABLE `desires` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
