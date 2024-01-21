<%
'@LANGUAGE="VBSCRIPT" CODEPAGE="65001"	
'code here
Dim connDB
set connDB = Server.CreateObject("ADODB.Connection")
Dim strConnection
strConnection = "Provider=SQLOLEDB.1;Data Source=DESKTOP-8RTP8V7;Database=web_acc_game;User Id=sa;Password=123456789"
connDB.ConnectionString = strConnection
%>