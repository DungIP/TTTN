<%
  Session.CodePage = 65001
  Response.charset ="utf-8"
Session.LCID     = 1033 'en-US
if (IsNull(Session("user")) or Session("user")="") then Response.redirect("../login.asp")
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="../admin/dist/css/adminlte.min.css">
  <link rel="stylesheet" href="history.css" />
  <title></title>
  <style>  
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    .app {
      flex: 1;
    }
   
  .scrollable-table {
    max-height: 300px;
    overflow-y: auto;
  }
  .history-table td {
    max-height: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .title {
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 30px;
    margin-bottom: 60px;
    margin-top: 10px;
    font-weight: bold;
    color: #3d3935;
  }
  </style>
</head>
<body>
  <div class="app">
    <!-- #include virtual ="header.asp" -->
    <!-- MAIN -->
    <div class="main">
      <div class="container">
        <div class="title">Acc Ghenshin đã mua</div>
        <div class="box">
          <div class="top">
             <!--  <div class="top-left">
                <div style="width: 17%">Copy</div>
                <div style="width: 17%">Excel</div>
                <div style="width: 17%">Print</div>
                <div style="width: 49%"> 
                  <select name="" id="">
                    <option value="">Column visibility</option>
                  </select>
                </div>
              </div> -->
              <div class="top-right">
                <label for="top-input">Search: </label>
                <input type="text" id="top-input">
              </div>
            </div>
            <div class="scrollable-table">
            <table class="history-table" id="myTable">
            <thead>
              <tr style="border: solid 1px #fff;">
                <td style="border: solid 1px #fff;width: 10%;">ID</td>
                <td style="border: solid 1px #fff;width: 15%;">Tên đăng nhập</td>
                <td style="border: solid 1px #fff;width: 15%;">Mật khẩu</td>
                <td style="border: solid 1px #fff;width: 20%;">Thông tin</td>
                <td style="border: solid 1px #fff;width: 10%;">Giá</td>
                <td style="border: solid 1px #fff;width: 20%;">Tiêu đề giới thiệu</td>
                <td style="border: solid 1px #fff;width: 10%;">Mua lúc</td>
              </tr>
            </thead>
            <tbody>
              <tr style="border: solid 1px #fff;">
                <td ><div class="scrollable-column" style="border: solid 1px #fff;" colspan="7">
                  No available data
                     </div>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr style="border: solid 1px #fff;">
                <td style="border: solid 1px #fff;width: 10%;">ID</td>
                <td style="border: solid 1px #fff;width: 15%;">Tên đăng nhập</td>
                <td style="border: solid 1px #fff;width: 15%;">Mật khẩu</td>
                <td style="border: solid 1px #fff;width: 20%;">Thông tin</td>
                <td style="border: solid 1px #fff;width: 10%;">Giá</td>
                <td style="border: solid 1px #fff;width: 20%;" >Tiêu đề giới thiệu</td>
                <td style="border: solid 1px #fff;width: 10%;">Mua lúc</td>
              </tr>
            </tfoot>

          </table>
          </div>
          <div class="bot">
            <div class="bot-left">
              <!-- Showing 0 to 0 to 0 entries -->

            </div>

            <div class="card-tools bot-right" id="paging">
              <ul class="pagination pagination-sm float-right">
                <li class="page-item"><a class="page-link" id="First">&laquo;</a></li>
                <li class="page-item"><a class="page-link" id="Previous">1</a></li>
                <li class="page-item"><a class="page-link" id="page_active">2</a></li>
                <li class="page-item"><a class="page-link" id="Next">3</a></li>
                <li class="page-item"><a class="page-link" id="last">&raquo;</a></li>
              </ul>
            </div>

          </div>
        </div>
      </div>
    </div>
    <div class="footer">
  <!-- #include virtual ="footer.asp" --></div>
  </div>
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
                          setPage_active(parseInt(localStorage.getItem('last_page_purchase_history'))-1);
                        });

                        $("#Previous").click(function(){
                          loadTable($('#Previous').text());
                          if ($('#Previous').text()!=="1") {
                            setPage_active(parseInt($('#Previous').text()));
                          }
                        });
                        $("#Next").click(function(){
                          loadTable($('#Next').text());
                          if ($('#Next').text()!==localStorage.getItem('last_page_purchase_history')) {
                            setPage_active(parseInt($('#Next').text()));
                          }
                        });

                        $("#page_active").click(function(){
                          loadTable($('#page_active').text());
                        });
 
                        $.post("../admin/api/getCount.asp",{table: "purchase_history", limit: 3, id: <%=JSON_Parse(Session("user"))("id")%>},
                          function(data,status){
                            localStorage.setItem('last_page_purchase_history', data);

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

                        $.post("../admin/api/purchase_history_list.asp",{page: page,id: <%=JSON_Parse(Session("user"))("id")%>},
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
                          row.insertCell(1).innerHTML = data[i].account_name;
                          row.insertCell(2).innerHTML = data[i].password;
                          row.insertCell(3).innerHTML = data[i].describe2;
                          row.insertCell(4).innerHTML = data[i].saleprice;
                          row.insertCell(5).innerHTML = data[i].describe;
                          row.insertCell(6).innerHTML = data[i].transaction_time;
                           
                         }
                      }
                      </script>
</body>
</html>