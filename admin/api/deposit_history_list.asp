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
                strSQL = "select count(id) AS count from deposit_history"
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
        cmdPrep.CommandText = "select deposit_history.id, account.user_name, transaction_value,payment_method.name as payment_method, transaction_time from account, deposit_history, payment_method where account.id = deposit_history.account_id and payment_method.id = deposit_history.payment_method order by deposit_history.id  asc  offset ? rows fetch next ? rows only"
        cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
        cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)

        Set Result = cmdPrep.execute

        Response.Write("[")
                do while not Result.EOF

 			Response.Write("{")  
 
         			Response.Write("""id"": """& Result("id") &""",")	 
         			Response.Write("""user_name"": """& Result("user_name") &""",")
         			Response.Write("""transaction_value"": """& Result("transaction_value") &""",")
                                Response.Write("""payment_method"": """& Result("payment_method") &""",")
                                Response.Write("""transaction_time"": """& Result("transaction_time") &"""")

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