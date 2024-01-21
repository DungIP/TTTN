<!-- #include virtual="admin/connect.asp" -->
<%
function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number Then
            Ceil = Ceil + 1
        end if
end function

Dim limit, table, id
limit = CInt(Request.Form("limit"))
table = Request.Form("table")
id = Request.Form("id")


strSQL = "select count(id) as count from " & table
if NOT isnull(id) and id <> "" then strSQL=strSQL&" WHERE account_id = "&id
    connDB.Open()
        Set CountResult = connDB.execute(strSQL)
        totalRows = CLng(CountResult("count"))
        Response.Write(Ceil(totalRows/limit))              
    connDB.Close()   

%>