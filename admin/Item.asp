<!-- #include file="connect.asp" -->
<!--#include file="upload.lib.asp"-->

<%
  Response.Charset = "ISO-8859-1"
  Dim Form : Set Form = New ASPForm
  Server.ScriptTimeout = 1440 ' Limite de 24 minutos de execu��o de c�digo, o upload deve acontecer dentro deste tempo ou ent�o ocorre erro de limite de tempo.
  Const MaxFileSize = 10240000 ' Bytes. Aqui est� configurado o limite de 100 MB por upload (inclui todos os tamanhos de arquivos e conte�dos dos formul�rios).
  If Form.State = 0 Then

    If (Request.ServerVariables("REQUEST_METHOD") = "POST") THEN   

      Dim name, type_item
      name = Form.Texts.Item("name")
      type_item = Form.Texts.Item("type_item")

      if NOT isnull(name) and name <> "" then

        connDB.Open()  
        Set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "insert into item(name, type_item) VALUES(?,?)"

        cmdPrep.parameters.Append cmdPrep.createParameter("name",202,1,255,name)
        cmdPrep.parameters.Append cmdPrep.createParameter("type_item",202,1,255,type_item)

        For each Field in Form.Files.Items

          Field.SaveAs Server.MapPath(".") & "\images\" & Form.Texts.Item("name") & ".png"
        Next
        
        cmdPrep.execute               
      End if  
    End if  
  End If


%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin | Form Account Game </title>

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
            <h1 class="m-0">Form Input Item in Game</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Item</li>
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
            <h3 class="card-title">Add New Item in Game</h3>
          </div>
          <!-- /.card-header -->
          <!-- form start -->
          <form action="item.asp" method="post" enctype="multipart/form-data">
            <div class="card-body">
              <div class="form-group">
                <label for="name">name</label>
                <input type="text" class="form-control" id="name" placeholder="Enter name" name="name" required>
              </div>

              <div class="form-group">
                <label for="icon">upload file icon</label>
                <div class="input-group">
                  <div class="custom-file">
                    <input type="file" class="custom-file-input" id="icon" name="icon" required multiple>
                    <label class="custom-file-label" for="icon">Choose file</label>
                  </div>
                </div>
              </div>

              <div class="form-group">
                <label for="type_item" >Type Item</label>
                <select id="type_item" name="type_item" class="form-control">
                  <option value="Characters">Characters</option>
                  <option value="Weapons">Weapons</option>
                </select>
              </div>

              <!-- /.card-body -->

              <div class="card-footer">
                <button type="submit" class="btn btn-primary" value="Upload">Submit</button>
              </div>
            </form>
          </div>
          <!-- /.card -->

        </div><!-- /.container-fluid -->

      </section>

      <script src="plugins/jquery/jquery.min.js"></script>
      <script src="plugins/bs-custom-file-input/bs-custom-file-input.min.js"></script>
      <script>
        $(function () {
          bsCustomFileInput.init();
        });
      </script>

      <!-- #include file="footer.asp" -->
    </body>
    </html>