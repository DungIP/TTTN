<%
  if (NOT IsNull(Request.QueryString("id")) and Request.QueryString("id") <> "") then Response.redirect("../detail.asp?id="&Request.QueryString("id"))
  %>
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="index.css" />
    <title>home</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
    <link rel="stylesheet" href="path/multiPicks.css"/>
  </head>

  <body>
    <div class="app">
      <!--#include virtual="header.asp" -->
      <!-- #include virtual ="admin/connect.asp" -->
      <div class="form-container">
    <form>
      <!-- Add your form fields here -->
    </form>
     
      <!-- MAIN -->
      <div class="main">
    
        <div class="container">
          <div class="search-box">
            <div class="search">
              <span>Tìm Kiếm</span>
            </div>
            <div class="empty">
              <span>Bỏ trống tùy ý</span>
            </div>
            <form class="form" action="index.asp" method="GET" onsubmit="return handleSubmit(event)">
              <input type="hidden" id="item_json_h" name="item_json">
              <div class="input-div">
                <div class="input-title">Tướng 5*</div>
                <div class="form-group">
                  <select id="item_json_Characters" class="form-control">
                    <%
                      connDB.Open()
                      Set cmdPrep = Server.CreateObject("ADODB.Command")
                      cmdPrep.ActiveConnection = connDB
                      cmdPrep.CommandType = 1
                      cmdPrep.Prepared = True
                      cmdPrep.CommandText = "SELECT * FROM item WHERE type_item = ?"
                      cmdPrep.parameters.Append cmdPrep.createParameter("type_item",202,1,255,"Characters")

                      Set Result = cmdPrep.execute

                      do while not Result.EOF

                        Response.Write("<option value="""&Result("id")&""" data-img=""images/"&Result("name")&".png"">"&Result("name")&"</option>")    

                        Result.MoveNext
                      loop
                      connDB.Close() 
                    %>

                  </select>
                </div>
              </div>
              <div class="input-div">
                <div class="input-title">Vũ khí</div>
                <div class="form-group">
                  <select id="item_json_Weapons" class="form-control">
                    <%
                      connDB.Open()
                      Set cmdPrep = Server.CreateObject("ADODB.Command")
                      cmdPrep.ActiveConnection = connDB
                      cmdPrep.CommandType = 1
                      cmdPrep.Prepared = True
                      cmdPrep.CommandText = "SELECT * FROM item WHERE type_item = ?"
                      cmdPrep.parameters.Append cmdPrep.createParameter("type_item",202,1,255,"Weapons")

                      Set Result = cmdPrep.execute

                      do while not Result.EOF

                        Response.Write("<option value="""&Result("id")&""" data-img=""images/"&Result("name")&".png"">"&Result("name")&"</option>")    

                        Result.MoveNext
                      loop
                      connDB.Close() 
                    %>

                  </select>
                </div>
              </div>
              <div class="input-div">
                <div class="input-title">AR</div>
                <input type="number" name="adventure_rank" />
              </div>
              <div class="input-div">
                <div class="input-title">Giá</div>
                <select class="form-control" name="price">
                  <option value="0 AND 999999999">Chọn giá</option>
                  <option value="1 AND 10000">10k trở xuống</option>
                  <option value="10000 AND 50000">10K - 50K</option>
                  <option value="50000 AND 100000">50K - 100K</option>
                  <option value="100000 AND 200000">100K - 200K</option>
                  <option value="200000 AND 300000">200K - 300K</option>
                  <option value="300000 AND 400000">300K - 400K</option>
                  <option value="400000 AND 500000">400K - 500K</option>
                  <option value="500000 AND 800000">500K - 800K</option>
                  <option value="800000 AND 1000000">800K - 1tr</option>
                  <option value="1000000 AND 5000000">1tr - 5tr</option>
                  <option value="5000000 AND 999999999">Trên 5tr</option>
                </select>
              </div>
              <div class="input-sx">
                <div>
                  <div class="input-title"> Giá</div>
                  <select class="form-control" name="sort_price">
                    <option value="asc">Tăng dần</option>
                    <option value="desc">Giảm dần</option>
                  </select>
                </div>
                <div>
                  <div class="input-title">Server</div>
                  <select class="form-control" name="sever">
                   <option value="Asia">Asia</option>
                   <option value="Europe">Europe</option>
                   <option value="America">America</option>
                   <option value="TW,HK,MO">TW,HK,MO</option>
                 </select>
               </div>
             </div>
             <div class="sid">
              <div><span>Mã Số</span></div>
              <div><input type="number" name="id"/></div>
            </div>
            <div class="submit">
              <button type="submit">Tìm Kiếm</button>
            </div>
          </form>
        </div>
        <div class="list-item">
         <div class="list-page">
          <div class="pages">
            <div class="page"><span id="First"> < </span></div>
            <div class="page page-active"><span id="Previous"> 1 </span></div>
            <div class="page"><span id="page_active"> 2 </span></div>
            <div class="page"><span id="Next"> 3 </span></div>
            <div class="page"><span id="last"> > </span></div>
          </div>
        </div>
        <div class="list-item" id="cardContainer" style="width:100%"></div>
      </div>
    </div>
  </div>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

  <script type="text/javascript">


    function createCard(data, item_list) {
          // Create the card element
      var card = document.createElement("div");
      card.className = "item_card";
      var jsonArray = JSON.parse(data.item_json);

      var desCharacters = document.createElement("div");
      var desWeapons = document.createElement("div");
      desCharacters.className = "list-hero";
      desWeapons.className = "list-hero";

      for (var i = 0; i < jsonArray.length; i++) {
        var element = jsonArray[i];
        var item = item_list.find(function (i) {
          return i.id == element;
        });

        var item_Html = document.createElement("div");
        item_Html.innerHTML = '<img src="../admin/images/' + item.name + '.png" alt="Image"/>';
        console.log(item.type_item);
        if (item.type_item == "Characters") {
          desCharacters.appendChild(item_Html);
        } else {
          desWeapons.appendChild(item_Html);
        }
      }

          // Create the card content using the data retrieved through AJAX
          // You can access the data using properties like data.id, data.image, data.price, etc.
      card.innerHTML = `
      <div class="id">#${data.id}</div>
      <div class="image">
      <img src="${data.image}" alt="" />
      <div class="price">${new Intl.NumberFormat().format(data.price)}</div>
      </div>
      <div class="position">
      <div class="position">
      <div class="position-item">
      <div style="opacity: 0.7">AR Level</div>
      <div>${data.adventure_rank}</div>
      </div>
      <div class="position-item">
      <div style="opacity: 0.7">Khu Vực</div>
      <div>${data.sever}</div>
      </div>
      <div class="position-item">
      <div style="opacity: 0.7">Tướng</div>
      <div>${data.characters}</div>
      </div>
      </div>
      </div>
      <div class="info">
      <span>${data.describe}</span>
      </div>
      <div class="hero">
      <div class="hero-title">Tướng : ${data.characters}</div>
      ${desCharacters.outerHTML}
      </div>
      <div class="hero">
      <div class="hero-title">vũ khí : ${data.weapons}</div>
      ${desWeapons.outerHTML}
      </div>
      <div class="detail"><a href="../detail.asp?id=${data.id}">Chi Tiết</div>
      `;

          // Append the card to the container
      document.getElementById("cardContainer").appendChild(card);
    }


    $(document).ready(function(){
      loadTable(1);
      $("#First").click(function(){
        loadTable(1);
        setPage_active(2);
        setPage_class_active("#Previous");
      });
      $("#last").click(function(){
        loadTable(0);
        setPage_active(parseInt(localStorage.getItem('last_page_account_game'))-1);
        setPage_class_active("#Next");
      });

      $("#Previous").click(function(){
        loadTable($('#Previous').text());
        if ($('#Previous').text()!=="1") {
          setPage_active(parseInt($('#Previous').text()));
          setPage_class_active("#page_active");
        }
        else{
          setPage_class_active("#Previous");
        }
      });
      $("#Next").click(function(){
        loadTable($('#Next').text());
        if ($('#Next').text()!==localStorage.getItem('last_page_account_game')) {
          setPage_active(parseInt($('#Next').text()));
          setPage_class_active("#page_active");
        }
        else{
          setPage_class_active("#Next");
        }
      });

      $("#page_active").click(function(){
        loadTable($('#page_active').text());
        setPage_class_active("#page_active");
      });

      $.post("../admin/api/getCount.asp",{table: "account_game", limit: 9},
        function(data,status){
          localStorage.setItem('last_page_account_game', data);

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

    function setPage_class_active(page){
      $("#Previous").parent().removeClass("page-active");
      $("#page_active").parent().removeClass("page-active");
      $("#Next").parent().removeClass("page-active");
      $(page).parent().addClass("page-active");
    }
    function setPage_active(page){
      $('#page_active').text(page);
      $('#Previous').text(page-1);
      $('#Next').text(page+1);
    }

    function loadTable(page){
      document.getElementById("cardContainer").innerHTML = "";
      $.post("../admin/api/item_list.asp", { page: -1 }, function (d, status) {
        var item_list = JSON.parse(d);
        const params = new URLSearchParams(window.location.search);
        console.log(params.get('adventure_rank'));
        $.post("../admin/api/account_game_list.asp", { 
          page: page ,
          adventure_rank : params.get('adventure_rank'),
          price : params.get('price'),
          sort_price : params.get('sort_price'),
          sever : params.get('sever'),
          item_json : params.get('item_json')
        }, function (data, s) {
         console.log(JSON.parse(data));
         data1 = JSON.parse(data);
         for (var i = 0; i < data1.length; i++) {
          createCard(data1[i], item_list);
        }
      });
      });
    }

  </script>


  <script src="path/multiPicks.js"></script>
  <script type="text/javascript" >
    $('#item_json_Characters').multiPick({

          // max number of options 
      limit: 10,

          // enable images
      image: false,

          // close the select after selection
      closeAfterSelect: false,

          // enable search field
      search: false,

          // placeholder text
      placeholder: 'Select',

          // slim layout
      slim: false,

    });
    $('#item_json_Weapons').multiPick({

          // max number of options 
      limit: 10,

          // enable images
      image: false,

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

     let idCharacters = $('#item_json_Characters').prop('id');
     let idWeapons = $('#item_json_Weapons').prop('id');

     var value = [];

     let itens = $(`#${idCharacters}`).find(`.main-content .selected-itens .item`);

     for (var i = 0; i < itens.length; i++) {
      let item = itens[i];

      value.push($(item).data('value'));
      console.log(value);
    }
    itens = $(`#${idWeapons}`).find(`.main-content .selected-itens .item`);

    for (var i = 0; i < itens.length; i++) {
      let item = itens[i];

      value.push($(item).data('value'));
    }
    console.log(JSON.stringify(value));

    document.getElementById("item_json_h").value = JSON.stringify(value);

    return true;
  }
</script>
<!-- #include virtual ="footer.asp" -->
</div>
</body>
<link rel="stylesheet" href="path/multiPicks.css"/>
</html>