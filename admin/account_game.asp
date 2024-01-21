<!-- #include file="connect.asp" -->
<%
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then  
   
    Dim price, sever, adventure_rank, characters, weapons, describe, account_name, password, item_json
    
    price = CDbl(Request.Form("price"))
    sever = Request.Form("sever")
    adventure_rank = CInt(Request.Form("adventure_rank"))
    characters = CInt(Request.Form("characters"))
    weapons = CInt(Request.Form("weapons"))
    describe = Request.Form("describe")
    account_name = Request.Form("account_name")
    password = Request.Form("password")
    item_json = Request.Form("item_json")
    image = Request.Form("image")

    if NOT isnull(item_json) and item_json <> "" and NOT isnull(describe) and describe <> "" and NOT isnull(account_name) and account_name <> "" and NOT isnull(password) and password <> "" then

      connDB.Open()  
      Set cmdPrep = Server.CreateObject("ADODB.Command")
      cmdPrep.ActiveConnection = connDB
      cmdPrep.CommandType = 1
      cmdPrep.Prepared = True
      cmdPrep.CommandText = "insert into account_game(price,sever,adventure_rank,characters,weapons,describe,item_json,account_name,password,image) VALUES(?,?,?,?,?,?,?,?,?,?)"
      
      cmdPrep.parameters.Append cmdPrep.createParameter("price",5,1, , price)
      cmdPrep.parameters.Append cmdPrep.createParameter("sever",202,1,255,sever)
      cmdPrep.parameters.Append cmdPrep.createParameter("adventure_rank",3,1, , adventure_rank)
      cmdPrep.parameters.Append cmdPrep.createParameter("characters",3,1, , characters)
      cmdPrep.parameters.Append cmdPrep.createParameter("weapons",3,1, , weapons)
      cmdPrep.parameters.Append cmdPrep.createParameter("describe",202,1,255,describe)
      cmdPrep.parameters.Append cmdPrep.createParameter("item_json",202,1,255,item_json)
      cmdPrep.parameters.Append cmdPrep.createParameter("account_name",202,1,255,account_name)
      cmdPrep.parameters.Append cmdPrep.createParameter("password",202,1,255,password)
      cmdPrep.parameters.Append cmdPrep.createParameter("image",202,1,255,image)

      cmdPrep.execute   
      connDB.Close()              
    End if  
  End if     
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

  <link rel="stylesheet" href="/admin/path/multiPicks.css" />
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
  <script src="/admin/path/multiPicks.js"></script>
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
            <h1 class="m-0">Form Input Account Game</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">account_game</li>
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
            <h3 class="card-title">Add New Account Game</h3>
          </div>
          <!-- /.card-header -->
          <!-- form start -->
          <form action="account_game.asp" method="post" onsubmit="return handleSubmit(event)">
            <!--  -->
            <div class="card-body">
              <div class="form-group">
                <label for="account_name">Account</label>
                <input type="text" class="form-control" id="account_name" placeholder="Enter Account" name="account_name" required>
              </div>
              <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" placeholder="Enter Password" name="password" required>
              </div>
              <div class="form-group">
                <label for="image">image</label>
                <input type="text" class="form-control" id="image" placeholder="Enter image link" name="image" required>
              </div>
              <div class="form-group">
                <label for="sever" >sever</label>
                <select id="sever" name="sever" class="form-control">
                  <option value="Asia">Asia</option>
                  <option value="Europe">Europe</option>
                  <option value="America">America</option>
                  <option value="TW,HK,MO">TW,HK,MO</option>
                </select>
              </div>

              <div class="form-group">
                <label for="price">price</label>
                <input type="number" class="form-control" id="price" placeholder="Enter price" name="price" required>
              </div>


              <div class="form-group">
                <label for="adventure_rank">Adventure Rank</label>
                <input type="number" class="form-control" id="adventure_rank" placeholder="Enter Adventure Rank" name="adventure_rank" required>
              </div>  
                <!-- <div class="form-group">
                    <label for="characters">Characters</label>
                    <input type="number" class="form-control" id="characters" placeholder="Enter number of characters" name="characters" required>
                </div>  
                <div class="form-group">
                    <label for="weapons">Weapons</label>
                    <input type="number" class="form-control" id="weapons" placeholder="Enter number of Weapons" name="weapons" required>
                  </div>   -->
                  <label for="item_json">item</label>
                  <div class="form-group">
                    <select id="item_json" class="form-control">
                      <%
                        connDB.Open()
                        Set cmdPrep = Server.CreateObject("ADODB.Command")
                        cmdPrep.ActiveConnection = connDB
                        cmdPrep.CommandType = 1
                        cmdPrep.Prepared = True
                        cmdPrep.CommandText = "select * from item"
                        
                        Set Result = cmdPrep.execute

                        
                        do while not Result.EOF

                          Response.Write("<option value="""&Result("id")&""" data-img=""images/"&Result("name")&".png"">"&Result("name")&"</option>")    
                          
                          Result.MoveNext
                        loop
                        connDB.Close() 
                      %>

                    </select>
                  </div>

                  <input type="hidden" id="item_json_v" name="item_json">

                  <div class="form-group">
                    <label for="describe">describe</label>
                    <textarea class="form-control" id="describe" name="describe" required>Enter Describe</textarea>
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

          <script type="text/javascript">
            $('#item_json').multiPick({

          // max number of options 
              limit: 10,

          // enable images
              image: true,

          // close the select after selection
              closeAfterSelect: false,

          // enable search field
              search: false,

          // placeholder text
              placeholder: 'Select',

          // slim layout
              slim: false,
              
            });
            function handleSubmit(event) {

             let idItem = $('#item_json').prop('id');

             var value = [];

             let itens = $(`#${idItem}`).find(`.main-content .selected-itens .item`);

             for (var i = 0; i < itens.length; i++) {
              let item = itens[i];

              value.push($(item).data('value'));
            }
            console.log(JSON.stringify(value));

            document.getElementById("item_json_v").value = JSON.stringify(value);

            return true;
          }
          
        </script>


        <!-- #include file="footer.asp" -->
      </body>
      </html>