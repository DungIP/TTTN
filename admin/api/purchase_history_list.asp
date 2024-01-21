<!-- #include virtual="admin/connect.asp" -->

<%
        function Ceil(Number)
                Ceil = Int(Number)
                if Ceil<>Number Then
                    Ceil = Ceil + 1
            end if
    end function

    Dim offset, limit, page, id, strSQL
    limit = 3
    id = Request.Form("id")
    page = CInt(Request.Form("page"))
    if page = 0 then
        strSQL = "select count(id) AS count from deposit_history"
        if NOT isnull(id) and id <> "" then strSQL=strSQL&" WHERE account_id = "&id
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
        strSQL = ""
        if NOT isnull(id) and id <> "" then strSQL=" WHERE account_id = "&id

        cmdPrep.CommandText = "SELECT account_game.describe, account_game.account_name, account_game.password, purchase_history.id, account.user_name, purchase_history.account_game_id, purchase_history.transaction_time, purchase_history.saleprice, CONCAT('AR: ', account_game.adventure_rank, '<br>Server: ', account_game.sever) AS describe2 FROM account JOIN purchase_history ON account.id = purchase_history.account_id JOIN account_game ON purchase_history.account_game_id = account_game.id"&strSQL&" ORDER BY purchase_history.id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
        cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
        cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)

        Set Result = cmdPrep.execute

        Response.Write("[")
        do while not Result.EOF

            Response.Write("{")  

            Response.Write("""id"": """& Result("id") &""",")	 
            Response.Write("""describe2"": """& Result("describe2") &""",")
            Response.Write("""describe"": """& Result("describe") &""",")
            Response.Write("""account_name"": """& Result("account_name") &""",")
            Response.Write("""password"": """& Result("password") &""",")
            Response.Write("""user_name"": """& Result("user_name") &""",")
            Response.Write("""account_game_id"": """& Result("account_game_id") &""",")
            Response.Write("""saleprice"": """& Result("saleprice") &""",")
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