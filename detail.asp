<!-- #include virtual="admin/connect.asp" -->
<%

  dim id
  id = Request.QueryString("id")

  if (IsNull(id) or id="") then Response.redirect("index/index.asp")  

    connDB.Open()
    Set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "SELECT * FROM account_game WHERE id = ?"
    cmdPrep.Parameters.Append cmdPrep.CreateParameter(1, 3, 1, , id)

    Set Result = cmdPrep.execute

    If (Request.ServerVariables("REQUEST_METHOD") = "POST") THEN  
      if (IsNull(Session("user")) or Session("user")="") then Response.redirect("../login.asp")
        dim user_tmp
        set user_tmp = JSON_Parse(Session("user"))

        if CLng(user_tmp("account_balance")) >= CLng(Result("price")) then

          Set cmdPrep = Server.CreateObject("ADODB.Command")
          cmdPrep.ActiveConnection = connDB
          cmdPrep.CommandType = 1
          cmdPrep.Prepared = True
          cmdPrep.CommandText = "insert into purchase_history(account_id, account_game_id, saleprice) VALUES(?,?,?)"

          cmdPrep.parameters.Append cmdPrep.createParameter("account_id",3,1, , user_tmp("id"))
          cmdPrep.parameters.Append cmdPrep.createParameter("account_game_id",3,1, , id)
          cmdPrep.parameters.Append cmdPrep.createParameter("saleprice",3,1, , Result("price"))

          user_tmp("account_balance") = user_tmp("account_balance") - Result("price")
          Session("user")=JSON_Stringify(user_tmp)

          cmdPrep.execute   

          Session("Success")="Mua acc thành công"
          Response.redirect("history/history.asp")
        Else
        Session("Error")="Số dư khả dụng không đủ"
      End if

    End if


    Function ConvertJSONToFormat(jsonString)
      Dim cleanString
      cleanString = Replace(jsonString, "[", "(")
      cleanString = Replace(cleanString, "]", ")")

      ConvertJSONToFormat = cleanString
    End Function


  %>
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="detail.css" />
    <title></title>
    <style>
    h3 {

  color: rgb(231 195 19);

}
</style>
  </head>

  <body>
    <div class="app">
      <!-- #include file="header.asp" -->
      <!-- MAIN -->

      <div class="main">
        <div class="container">
          <div class="box">
            <h2>Chi tiết acc Normal #<%=id%></h2>
          
            <div class="box-info">
              <div class="box-top">
                <div class="box-item">
                  <div>CẤP AR</div>
                  <div><%=Result("adventure_rank")%></div>
                </div>
                <div class="box-item">
                  <div>KHU VỰC</div>
                  <div><%=Result("sever")%></div>
                </div>
                <div class="box-item">
                  <div>TƯỚNG 5*</div>
                  <div><%=Result("characters")%></div>
                </div>
              </div>
              <div class="box-main">
                <div class="main-info">
                  <%=Result("describe")%>
                </div>
                <div class="numbs-hero">
                  <div>TƯỚNG: <%=Result("characters")%></div>
                </div>
                <div class="box-image">
                  <div class="image-bound">
                    <%

                      cmdPrep.CommandText = "SELECT * FROM item WHERE id IN "&ConvertJSONToFormat(Result("item_json"))&" AND type_item = 'Characters'"

                      Set Result_item = cmdPrep.execute


                      do while not Result_item.EOF
                       Response.Write("<div class='image-item'><img src='admin/images/"&Result_item("name")&".png'/></div>")
                       Result_item.MoveNext
                     loop
                   %>

                 </div>
               </div>
               <div class="slice">
                <div>Vũ Khí: <%=Result("weapons")%></div>
              </div>
              <div class="box-image">
                <div class="image-bound">
                  <%

                    cmdPrep.CommandText = "SELECT * FROM item WHERE id IN "&ConvertJSONToFormat(Result("item_json"))&" AND type_item = 'Weapons'"

                    Set Result_item = cmdPrep.execute

                    do while not Result_item.EOF
                     Response.Write("<div class='image-item'><img src='admin/images/"&Result_item("name")&".png'/></div>")
                     Result_item.MoveNext
                   loop
                 %>

               </div>
             </div>
           </div>
         </div>
         <form class="box-active" action="detail.asp?id=<%=id%>" method="POST">
          <div class="active-first">
            <div><span><%=Replace(FormatNumber(Result("price"), 0, -1, -1, -1), ",", ".")%></span> <span class="price">đ</span></div>

            <%
              If Result("sold") = 0 Then
              %>
              <button type="submit"><span>Mua Ngay</span></button>
              <%                        
            Else
          %>                
          <div><span>Đã bán</span></div>
          <%
        End If
      %>


    </div>
  </form>
</div>
</div>
</div>
<%
  If (NOT IsEmpty(Session("Error")) AND NOT isnull(Session("Error"))) AND (TRIM(Session("Error"))<>"") Then
  %>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

  <script type="text/javascript">
    $(document).ready(function(){
     alert("<%=Session("Error")%>")
   });
 </script>
 <%
 Session.Contents.Remove("Error")
End If
%> 
<!-- #include file="footer.asp" -->
</div>
</body>
</html>
