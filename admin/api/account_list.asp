<!-- #include virtual="admin/connect.asp" -->

<%
function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number Then
            Ceil = Ceil + 1
        end if
end function

Dim offset, limit, page
limit = 3
page = CInt(Request.Form("page"))
        if page = 0 then
                strSQL = "select count(id) AS count from account"
                connDB.Open()
                    Set CountResult = connDB.execute(strSQL)
                    totalRows = CLng(CountResult("count"))
                    page = Ceil(totalRows/limit)               
                connDB.Close()      
        end if            
offset = (page-1) * limit

        connDB.Open()
        Set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "select account.id, user_name, email, password, role_account.name as role_account, account_balance from account, role_account where account.role_account = role_account.id order by account.id  asc  offset ? rows fetch next ? rows only"
        cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
        cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)

        Set Result = cmdPrep.execute

        Response.Write("[")
                do while not Result.EOF

 			Response.Write("{")  
 
         			Response.Write("""id"": """& Result("id") &""",")	 
         			Response.Write("""role_account"": """& Result("role_account") &""",")
         			Response.Write("""user_name"": """& Result("user_name") &""",")
         			Response.Write("""email"": """& Result("email") &""",")
         			Response.Write("""account_balance"": """& Result("account_balance") &"""")

			 
                        Result.MoveNext

                        if not Result.EOF then
                                Response.Write("},")  
                        else
                                Response.Write("}") 
                        end if    	
            
                loop
        connDB.Close()         
        Response.Write("]")  
%>