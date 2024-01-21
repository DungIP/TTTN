<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin | Dashboard </title>

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
            <h1 class="m-0">Item in Game</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">item_tbl</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

      <div class="container-fluid">


             <div class="card">
              <div class="card-header">
                <h3 class="card-title">Table Item in Game</h3>

                 <div class="card-tools" id="paging">
                  <ul class="pagination pagination-sm float-right">
                    <li class="page-item"><a class="page-link" id="First">&laquo;</a></li>
                    <li class="page-item"><a class="page-link" id="Previous">1</a></li>
                    <li class="page-item"><a class="page-link" id="page_active">2</a></li>
                    <li class="page-item"><a class="page-link" id="Next">3</a></li>
                    <li class="page-item"><a class="page-link" id="last">&raquo;</a></li>
                  </ul>
                </div>
              </div>

              <!-- /.card-header -->
              <div class="card-body p-0">
                <table class="table" id="myTable">
                  <thead>
                    <tr>
                      <th style="width: 10px">ID</th>
                      <th style="width: 40px">role</th>
                      <th>name</th>
                      <th>type item</th>
                    </tr>
                  </thead>
                  <tbody>
                  </tbody>
                </table>
              </div>
              <!-- /.card-body -->
            </div>
            <!-- /.card -->
    </div>

 <!-- #include file="footer.asp" -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                    <script>
                      $(document).ready(function(){
                        loadTable(1);
                        $("#First").click(function(){
                          loadTable(1);
                          setPage_active(2);
                        });
                        $("#last").click(function(){
                          loadTable(0);
                          setPage_active(parseInt(localStorage.getItem('last_page_item'))-1);
                        });

                        $("#Previous").click(function(){
                          loadTable($('#Previous').text());
                          if ($('#Previous').text()!=="1") {
                            setPage_active(parseInt($('#Previous').text()));
                          }
                        });
                        $("#Next").click(function(){
                          loadTable($('#Next').text());
                          if ($('#Next').text()!==localStorage.getItem('last_page_item')) {
                            setPage_active(parseInt($('#Next').text()));
                          }
                        });

                        $("#page_active").click(function(){
                          loadTable($('#page_active').text());
                        });
 
                        $.post("api/getCount.asp",{table: "item", limit: 3},
                          function(data,status){
                            localStorage.setItem('last_page_item', data);

                            if (data<=1) {
                              $("#paging").hide();
                            }
                            if (data==2) {
                              $("#Previous").hide();
                              $("#page_active").hide();
                              $("#Next").hide();
                            }
                          });
                        
                      });

                      function setPage_active(page){
                        $('#page_active').text(page);
                        $('#Previous').text(page-1);
                        $('#Next').text(page+1);
                      }

                      function loadTable(page){

                        $.post("api/item_list.asp",{page: page},
                          function(data,status){
                            console.log(JSON.parse(data));
                            populateTable(JSON.parse(data));
                          });
                      }

                      function populateTable(data) {
                        var table = document.getElementById("myTable");
                        var tbody = table.getElementsByTagName("tbody")[0];
                        tbody.innerHTML = "";
                        
                        for (var i = 0; i < data.length; i++) {
                          var row = tbody.insertRow(i);
                          row.insertCell(0).innerHTML = data[i].id;
                          row.insertCell(1).innerHTML = data[i].name;
                          row.insertCell(2).innerHTML = '<img src=\"images/'+data[i].name+'.png\" style=\"max-width: 108px\">';
                          row.insertCell(3).innerHTML = data[i].type_item;
                         }
                      }
                      </script>
 </body>
</html>