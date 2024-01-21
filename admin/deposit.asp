<!-- #include file="connect.asp" -->
<%
 If (Request.ServerVariables("REQUEST_METHOD") = "POST") THEN   

  Dim account_id, payment_method, transaction_value
  account_id = Request.Form("account_id")
  payment_method = Request.Form("payment_method")
  transaction_value = Request.Form("transaction_value")

    if NOT isnull(account_id) and account_id <> "" and NOT isnull(transaction_value) and transaction_value <> "" then

      connDB.Open()  
      Set cmdPrep = Server.CreateObject("ADODB.Command")
      cmdPrep.ActiveConnection = connDB
      cmdPrep.CommandType = 1
      cmdPrep.Prepared = True
      cmdPrep.CommandText = "insert into deposit_history(account_id, payment_method, transaction_value) VALUES(?,?,?)"
       
      cmdPrep.parameters.Append cmdPrep.createParameter("account_id",3,1, , account_id)
      cmdPrep.parameters.Append cmdPrep.createParameter("payment_method",3,1, , payment_method)
      cmdPrep.parameters.Append cmdPrep.createParameter("transaction_value",3,1, , transaction_value)

      scmdPrep.execute   
      connDB.Close()             
    End if  
End if     
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin | Form deposit Money</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
  <!-- overlayScrollbars -->
  <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.min.css">
</head>
 <body class="hold-transition dark-mode sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">

<!-- #include file="header.asp" -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Form Input deposit money</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">deposit</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->
    <section class="content">
      <div class="container-fluid">
         
            <!-- general form elements -->
            <div class="card card-primary">
              <div class="card-header">
                <h3 class="card-title">Deposit Money</h3>
              </div>
              <!-- /.card-header -->
              <!-- form start -->
              <form action="deposit.asp" method="post">
                <div class="card-body">
                  <div class="form-group">
                    <label for="account_id">account ID</label>
                    <input type="number" class="form-control" id="account_id" placeholder="Enter account ID" name="account_id" required>
                  </div>
                  <div class="form-group">
                    <label for="transaction_value">Transaction Value</label>
                    <input type="number" class="form-control" id="transaction_value" placeholder="Enter transaction value" name="transaction_value" required>
                  </div>
                   

                  <div class="form-group">
                    <label for="payment_method" >Payment Method</label>
                    <select id="payment_method" name="payment_method" class="form-control">
                      <%
                        connDB.Open()
                        Set cmdPrep = Server.CreateObject("ADODB.Command")
                        cmdPrep.ActiveConnection = connDB
                        cmdPrep.CommandType = 1
                        cmdPrep.Prepared = True
                        cmdPrep.CommandText = "select * from payment_method"
     
                        Set Result = cmdPrep.execute

                                          
                      do while not Result.EOF

                        Response.Write("<option value="""&Result("id")&""">"&Result("name")&"</option>")    
                      
                      Result.MoveNext
                      loop
                        connDB.Close() 
                      %>
                    </select>
                  </div>

                <!-- /.card-body -->

                <div class="card-footer">
                  <button type="submit" class="btn btn-primary">Submit</button>
                </div>
              </form>
            </div>
            <!-- /.card -->
           
      </div><!-- /.container-fluid -->

    </section>

 <!-- #include file="footer.asp" -->
 </body>
</html>