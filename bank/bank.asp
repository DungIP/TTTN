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
    <link rel="stylesheet" href="bank.css" />
    <title></title>
  </head>
  <body>
    <div class="app">
      <!-- #include virtual ="header.asp" -->
      <!-- MAIN -->
      <div class="main">
        <div class="container">
          <div class="title"></div>
          <div class="box">
            <div class="info-bank">
              <div class="info-title">Thông tin ngân hàng, ví</div>
              <table class="info-table">
                <tr>
                  <td class="bold">Thông tin</td>
                  <td class="bold">Số tài khoản</td>
                </tr>
                <tr>
                  <td>
                    <div class="bold">MOMO</div>
                    <div>Nguyễn Tiến Dũng</div>
                    <div>Chi nhánh: VN</div>
                  </td>
                  <td>
                    <div class="table-input">
                      <div id="MOMO">0978421357</div>
                      <div onclick="copyToClipboard('MOMO')">Copy</div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="bold">VCB</div>
                    <div>Nguyễn Tiến Dũng</div>
                    <div>Chi nhánh: VN</div>
                  </td>
                  <td>
                    <div class="table-input">
                      <div id="VCB">0329326246</div>
                      <div onclick="copyToClipboard('VCB')">Copy</div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="bold">BIDV</div>
                    <div>Nguyễn Tiến Dũng </div>
                    <div>Chi nhánh: VN</div>
                  </td>
                  <td>
                    <div class="table-input">
                      <div id="BIDV">0329326246</div>
                      <div onclick="copyToClipboard('BIDV')">Copy</div>
                    </div>
                  </td>
                </tr>
              </table>
            </div>
            <div class="direct">
              <div class="info-title" style="font-size: 28px;">Hướng dẫn</div>
              <div class="direct-content">
                <div class="pay-title">Nội dung chuyển tiền</div>
                <div class="direct-input">
                  <div id="NAP247">NAP247 <%=user("id")%></div>
                  <div onclick="copyToClipboard('NAP247')">Copy</div>
                </div>
              </div>
              <div class="rirect-detail-warn">
                Lưu ý hệ thống tự động  nên vui lòng chuyển khoản đúng nội dung ở trên
              </div>
              <div class="rirect-detail-warn">
                Lưu ý khách hàng sử dụng binance vui lòng chụp hình chuyển khoản gửi fanpage của shop
              </div>
              <div class="rirect-contact">
                Nếu chuyển sai vui lòng liên hệ admin hoặc số điện thoại 0328274491 để được hỗ trợ
              </div>
            </div>
          </div>
        </div>
      </div>
      <script type="text/javascript">
      function copyToClipboard(elementId) {
        // Get the element
        var element = document.getElementById(elementId);

        // Create a range object and select the element's text content
        var range = document.createRange();
        range.selectNode(element);

        // Add the range to the user's selection
        var selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);

        // Copy the selected content to the clipboard
        document.execCommand("copy");

        // Clear the selection
        selection.removeAllRanges();
      }
      </script>
      <!-- #include virtual ="footer.asp" -->
    </div>
  </body>
</html>