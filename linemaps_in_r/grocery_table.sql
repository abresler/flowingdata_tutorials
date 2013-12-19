--
-- Table structure for table `grocery`
--

CREATE TABLE IF NOT EXISTS `grocery` (
  `id` int(11) NOT NULL auto_increment,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;