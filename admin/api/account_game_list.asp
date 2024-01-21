<!-- #include virtual="admin/connect.asp" -->
<!-- #include virtual="admin/path/to/JSON_vbs.asp" -->
<%
        function Ceil(Number)
                Ceil = Int(Number)
                if Ceil<>Number Then
                    Ceil = Ceil + 1
            end if
    end function

    Dim offset, limit, page, adventureRank, price, sortPrice, accServer, sql, WHERE_sold, item_json
    WHERE_sold = ""
    adventureRank = Request.Form("adventure_rank")
    if  isnull(adventureRank) or adventureRank = ""  then adventureRank = 0
    price = Request.Form("price")
    sortPrice = Request.Form("sort_price")
    sever = Request.Form("sever")
    item_json = Request.Form("item_json")
    'If Not IsNull(Request.Form("item_json")) And Request.Form("item_json") <> "" Then item_json = JSON_Parse(Request.Form("item_json"))

    if JSON_Parse(Session("user"))("role_account") = 2 then WHERE_sold = "WHERE sold = 0"

    sql = "select * from account_game "&WHERE_sold&" order by account_game.id  asc  offset ? rows fetch next ? rows only"
 
        if NOT isnull(sortPrice) and sortPrice <> "" then
                  WHERE_sold = "sold = 0 and" 
                  sql = "select * from account_game where dbo.CheckJsonValuesExistInItemJson(item_json, '"&item_json&"') = 1 and "&WHERE_sold&" sever = '"&sever&"' and adventure_rank >= "&adventureRank&" and price between "&price&" order by price "&sortPrice&" offset ? rows fetch next ? rows only"

        end if     
 

limit = 9
page = CInt(Request.Form("page"))
if page = -1 then
        page = 1
        strSQL = "select count(id) AS count from account_game"
        connDB.Open()
        Set CountResult = connDB.execute(strSQL)
        totalRows = CLng(CountResult("count"))
        connDB.Close()
        limit = totalRows
end if            
if page = 0 then
        strSQL = "select count(id) AS count from account_game"
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
cmdPrep.CommandText = sql
cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)

Set Result = cmdPrep.execute

Response.Write("[")        
do while not Result.EOF

    Response.Write("{")  

    Response.Write("""id"": """& Result("id") &""",")    
    Response.Write("""price"": """& Result("price") &""",")
    Response.Write("""sever"": """& Result("sever") &""",")
    Response.Write("""adventure_rank"": """& Result("adventure_rank") &""",")
    Response.Write("""characters"": """& Result("characters") &""",")
    Response.Write("""weapons"": """& Result("weapons") &""",")
    Response.Write("""describe"": """& Result("describe") &""",")
    Response.Write("""item_json"": """& Result("item_json") &""",")
    Response.Write("""account_name"": """& Result("account_name") &""",")
    Response.Write("""password"": """& Result("password") &""",")
    Response.Write("""sold"": """& Result("sold") &""",")
    Response.Write("""image"": """& Result("image") &"""")

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