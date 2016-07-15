-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2016 年 7 朁E14 日 06:51
-- サーバのバージョン： 10.1.13-MariaDB
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mini_bbs`
--

-- --------------------------------------------------------

--
-- テーブルの構造 `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(100) NOT NULL,
  `picture` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `members`
--

INSERT INTO `members` (`id`, `name`, `email`, `password`, `picture`, `created`, `modified`) VALUES
(3, 'test', 'test@example.jp', 'a94a8fe5ccb19ba61c4c0873d391e987982fbbd3', '20160610095430c.png', '2016-06-10 09:54:37', '2016-06-10 07:54:37'),
(4, 'kishimen', 'kishimen@udon.jp', 'eb28c38a3fceb4530769a69a2cc90c53d1803d7b', '20160610100403chigusatei.jpg', '2016-06-10 10:04:04', '2016-06-10 08:04:04'),
(5, 'xampp', 'xampp@localhost.jp', '93b459871c44d027179a1324382a9f28c6d6529a', '20160610100534xampp.png', '2016-06-10 10:05:36', '2016-06-10 08:05:36');

-- --------------------------------------------------------

--
-- テーブルの構造 `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `member_id` int(11) NOT NULL,
  `reply_post_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `posts`
--

INSERT INTO `posts` (`id`, `message`, `member_id`, `reply_post_id`, `created`, `modified`) VALUES
(19, 'aa', 4, 0, '2016-06-10 22:11:29', '2016-06-10 13:11:29'),
(20, 'ウドンウマイ', 4, 0, '2016-06-11 20:28:28', '2016-06-11 11:28:28'),
(21, 'testtest', 3, 0, '2016-06-11 20:29:23', '2016-06-11 11:29:23'),
(22, 'MAMP', 5, 0, '2016-06-11 20:30:39', '2016-06-11 11:30:39'),
(23, 'xampp', 5, 0, '2016-06-11 20:31:37', '2016-06-11 11:31:37'),
(24, 'amp', 5, 0, '2016-06-11 20:31:41', '2016-06-11 11:31:41'),
(25, '(≧▽≦)', 3, 0, '2016-06-11 20:32:20', '2016-06-11 11:32:20'),
(26, '(*''▽'')', 3, 0, '2016-06-11 20:32:26', '2016-06-11 11:32:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
