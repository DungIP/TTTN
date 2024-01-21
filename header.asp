<!-- #include virtual="admin/path/to/JSON_vbs.asp" -->
<div class="header">
  <div class="container">
    <div class="logo">
      <a href="../index/index.asp"><img class="logo-img" src="https://www.freepnglogos.com/uploads/genshin-impact-logo-png/genshin-impact-shadow-logo-by-kurikuo-steamgriddb-4.png" alt="" /></a>
    </div>
    <div class="menu">
      <div class="menu-item"></div>
      <div class="menu-item">
        <a class="menu-text" href="../bank/bank.asp" style="text-decoration: none;">Nạp Tiền</a>
      </div>
      <div class="menu-item">
        <a class="menu-text" href="../history/history.asp" style="text-decoration: none;">Lịch Sử Mua</a>
      </div>
      <div class="menu-item">
        <a class="menu-text" href="../index/index.asp" style="text-decoration: none;">Menu Của Shop</a>
      </div>
    </div>
  </div>
  <% 
    Session.CodePage = 65001
    Response.charset = "utf-8"
    Session.LCID = 1033 'en-US
    If IsNull(Session("user")) Or Session("user") = "" Then 
  %>
  <div class="action">
    <div class="action-item">
    <button class="button-link" style="  background-color: yellow;
  color: black;
  border: none;
  width: 90px;
  height: 40px;
  text-align: center;
  text-decoration: none;
  font-size: 14px;
 
  cursor: pointer; " onclick="window.location.href='../login.asp'">
  Login
</button>
   <button class="button-link" style="  background-color: yellow;
  color: black;
  border: none;
  width: 105px;
  height: 40px;
  text-align: center;
  text-decoration: none;
  font-size: 14px;
  cursor: pointer; " onclick="window.location.href='../register.asp'">
  Register
</button>
    </div>
  </div>
  <%                        
    Else
      Dim user
      Set user = JSON_Parse(Session("user"))
  %>  
  <div class="action">
    <div class="action-item">
      <span class="register">
        <span>[<%=user("id")%>]</span>
        <span><%=user("user_name")%>:</span>
        <span style="color: rgb(255, 8, 0)"><%=Replace(FormatNumber(user("account_balance"), 0, -1, -1, -1), ",", ".")%>đ</span>
      </span>
      <div class="logout-active"><a href="../admin/logout.asp">Thoát</a></div>
    </div>
  </div>
  <%
    End If
  %>
</div>
