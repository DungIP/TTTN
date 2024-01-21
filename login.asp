<!-- #include virtual="admin/connect.asp" -->
<!-- #include file="admin/path/to/JSON_vbs.asp" -->
<%
Dim email, password
email = Request.Form("email")
password = Request.Form("password")
If (NOT isnull(email) AND NOT isnull(password) AND TRIM(email)<>"" AND TRIM(password)<>"") Then
    ' true
    
    Dim cmdPrep
    set cmdPrep = Server.CreateObject("ADODB.Command")
    connDB.Open()
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType=1
    cmdPrep.Prepared=true
    cmdPrep.CommandText = "select * from account where email= ? and password= ?"
    cmdPrep.Parameters(0)=email
    cmdPrep.Parameters(1)=password
    Dim result
    set result = cmdPrep.execute()
     If not result.EOF Then
        ' dang nhap thanh cong
        Dim user
		Set user = CreateObject("Scripting.Dictionary")
		user("id") = result("id")
		user("user_name") = result("user_name")
		user("email") = result("email")
		user("role_account") = result("role_account")
		user("account_balance") = result("account_balance")

        Session("user")=JSON_Stringify(user)

        Session("user_name")=result("user_name")
        Session("Success")="Login Successfully"
         if result("role_account") = 1 then
            Response.redirect("admin/index.asp")
        Else   
            Response.redirect("index/index.asp")
        End if 
    Else
        ' dang nhap ko thanh cong
        Session("Error") = "Invalid email or password. Please check your credentials and try again."
    End if
    result.Close()
    connDB.Close()

End if
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
	<title>Log In</title>
	<link rel="stylesheet" type="text/css" href="login.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

</head>
<body>
 <div class="container">
    <%
        If (NOT IsEmpty(Session("Error")) AND NOT isnull(Session("Error"))) AND (TRIM(Session("Error"))<>"") Then
    %>
            <div class="alert alert-danger mt-2" role="alert">
                <%=Session("Error")%>
            </div>
    <%
            Session.Contents.Remove("Error")
        End If
    %> 
    <h1>Log In</h1>

	<form action="login.asp" method="post">
		<label for="email">Account:</label>
		<input type="email" id="email" name="email" required><br><br>

		<label for="password">Password:</label>
		<input type="password" id="password" name="password" required><br><br>

		<input type="submit" class="btnDBN" value="Log In">

        <a href="register.asp" class="btnDK">Sign Up
		</a>
	</form>
  </div>  
</body>
</html>