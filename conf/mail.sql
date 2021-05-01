REPLACE INTO `settings` (`key`, `value`) VALUES
  ('mail_driver', 'mail'),
  ('mail_encryption', 'ssl'),
  ('mail_from', '$app@$domain'),
  ('mail_host', 'localhost'),
  ('mail_port', '587')
  AS new
ON DUPLICATE KEY UPDATE
value = new.value;
