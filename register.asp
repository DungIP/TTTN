<!-- #include file="admin/connect.asp" -->
<%
 If (Request.ServerVariables("REQUEST_METHOD") = "POST") THEN   

  Dim user_name, email, password
  user_name = Request.Form("user_name")
  email = Request.Form("email")
  password = Request.Form("password")

    if NOT isnull(user_name) and user_name <> "" and NOT isnull(email) and email <> "" then

      connDB.Open()  
      Set cmdPrep = Server.CreateObject("ADODB.Command")
      cmdPrep.ActiveConnection = connDB
      cmdPrep.CommandType = 1
      cmdPrep.Prepared = True
      cmdPrep.CommandText = "insert into account(user_name, email, password) VALUES(?,?,?)"
       
      cmdPrep.parameters.Append cmdPrep.createParameter("user_name",202,1,255,user_name)
      cmdPrep.parameters.Append cmdPrep.createParameter("email",202,1,255,email)
      cmdPrep.parameters.Append cmdPrep.createParameter("password",202,1,255,password)

      cmdPrep.execute        
      connDB.Close()
      Response.redirect("login.asp")       
    End if  
End if     
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Sign Up</title>
	<link rel="stylesheet" type="text/css" href="register.css">
</head>
<body>
	<h1>Sign Up</h1>
	<form action="register.asp" method="POST" onsubmit="return validatePassword()">
		
		<label for="user_name">Use Name:</label>
		<input type="text" id="user_name" name="user_name" required><br><br>

		<label for="email">Email:</label>
		<input type="email" id="email" name="email" required><br><br>
		
		<label for="password">Password:</label>
		<input type="password" id="password" name="password" required><br><br>

		<label for="confirm_password">Enter the password:</label>
		<input type="password" id="confirm_password" required><br><br>
			
		<button type="submit" class="btn btn-primary">
			Sign up
		</button>
		<a href="login.asp" class="btnDBN">Login
		</a>
 
	</form>

	<script type="text/javascript">
	function validatePassword() {
	  var password = document.getElementById("password").value;
	  var confirmPassword = document.getElementById("confirm_password").value;

	  if (password !== confirmPassword) {
	    // Passwords don't match
	    alert("Passwords do not match. Please try again.");
	    return false;
	  }

	  // Passwords match
	  return true;
	}
	</script>
</body>
</html>