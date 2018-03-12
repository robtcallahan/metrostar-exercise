<?php

$mysqli = new mysqli("db_endpoint", "rob", "dinx9one", "exercisedb");

if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

if (!$mysqli->real_query("SELECT * FROM user WHERE username='rcallahan';")) {
    echo "Getting user from DB failed: (" . $mysqli->errno . ") " . $mysqli->error;
}
$res = $mysqli->use_result();
$row = $res->fetch_assoc();
?>

<table width=500>
  <tr><td>First Name</td><td><?php echo $row['firstName']; ?><td></tr>
  <tr><td>Last Name</td><td><?php echo $row['lastName']; ?><td></tr>
  <tr><td>Username</td><td><?php echo $row['username']; ?><td></tr>
  <tr><td>EMail</td><td><?php echo $row['email']; ?><td></tr>
  <tr><td>Mobile Phone</td><td><?php echo $row['mobilePhone']; ?><td></tr>
  <tr><td>Created Date</td><td><?php echo $row['createdTime']; ?><td></tr>
  <tr><td>Updated Date</td><td><?php echo $row['updatedTime']; ?><td></tr>
</table>
