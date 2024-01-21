<!-- #include file="path/to/JSON_vbs.asp" -->
<%
Session.CodePage = 65001
Response.charset ="utf-8"
Session.LCID     = 1033 'en-US
if (IsNull(Session("user")) or Session("user")="") or JSON_Parse(Session("user"))("role_account") <> 1 then Response.redirect("../login.asp")

%>
<link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
<div class="wrapper">

  <!-- Preloader -->
<!--   <div class="preloader flex-column justify-content-center align-items-center">
    <img class="animation__wobble" src="dist/img/AdminLTELogo.png" alt="AdminLTELogo" height="60" width="60">
  </div> -->

  <!-- Navbar -->
  <nav class="main-header navbar navbar-expand navbar-dark">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="index.asp" class="nav-link">Home</a>
      </li>
    </ul>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto">
      <li class="nav-item">
        <a class="nav-link" href="logout.asp"  >
          <i class="fa fa-sign-out fa-5 " aria-hidden="true"></i>
        </a>
      </li>
    </ul>

  </nav>
  <!-- /.navbar -->

  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="index.asp" class="brand-link">
      <img src="dist/img/AdminLTELogo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
      <span class="brand-text font-weight-light">Admin</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <img src="dist/img/user2-160x160.jpg" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">
          <a href="#" class="d-block"><%Response.Write(Session("user_name"))%></a>
        </div>
      </div>


      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          
    
          <li class="nav-item">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-edit"></i>
              <p>
                Forms
                <i class="fas fa-angle-left right"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">

              <li class="nav-item">
                <a href="account_game.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Account Game</p>
                </a>
              </li> 

               <li class="nav-item">
                <a href="item.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Item in Game</p>
                </a>
              </li> 

              <li class="nav-item">
                <a href="deposit.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>deposit money</p>
                </a>
              </li> 


            </ul>
          </li>
          <li class="nav-item">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-table"></i>
              <p>
                Tables
                <i class="fas fa-angle-left right"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="account.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Tables Account User</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="account_game_tbl.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Tables Account Sell</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="item_tbl.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Tables Item</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="deposit_history.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Tables Deposit History</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="purchase_history.asp" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Tables Purchase History</p>
                </a>
              </li>
           
            </ul>
          </li>
        
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>