<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html lang="en"> 
<head>
  <title>Spring MVC02</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script type="text/javascript">
  	$(document).ready(function() {
  		loadList();
  	});
  	function loadList(){
  		// 서버와 통신 : 게시판 리스트 가져오기
  		$.ajax({
  			url: "boardList.do",
  			type: "get",
  			dataType: "json",
  			success: makeView, /* <- 콜백함수 */
  			error: function(){alert("error");}
  		});
  	}
  	/* data파라미터는 서버에서 받은 JSON 데이터이다. */
  							  //	 	  0     1     2
  	function makeView(data) { // data = [{  }, {  }, {  },,, ]
  		var listHtml = "<table class='table table-bordered'>";
  			listHtml += "<tr>";
  			listHtml += "<td>번호</td>";
  			listHtml += "<td>제목</td>";
  			listHtml += "<td>작성자</td>";
  			listHtml += "<td>작성일</td>";
  			listHtml += "<td>조회수</td>";
  			listHtml += "</tr>";
  			$.each(data, function (index, obj){	// obj={"idx":5, "title":"게시판" ~~}
				listHtml += "<tr>";
	  			listHtml += "<td>" +obj.idx+ "</td>";
	  			listHtml += "<td id='t"+obj.idx+"'><a href='javascript:goContent(" + obj.idx + ")'>" +obj.title+ "</a></td>";
	  			listHtml += "<td>" +obj.writer+ "</td>";
	  			listHtml += "<td>" +obj.indate.split('')[0]+ "</td>";
	  			listHtml += "<td id='cnt"+obj.idx+"'>" +obj.count+ "</td>";
	  			listHtml += "</tr>";
	  			
	  			listHtml += "<tr id='c" + obj.idx + "' style='display:none'>";
	  			listHtml += "<td>내용</td>";
	  			listHtml += "<td colspan='4'>";
	  			listHtml += "<textarea id='ta" + obj.idx + "' readonly rows='7' class='form-control'></textarea>"
	  			listHtml += "<br/>";
	  			listHtml += "<span id='ub" +obj.idx+ "'><button class='btn btn-success btn-sm' onclick='goUpdateForm(" + obj.idx + ")'>수정화면</button></span>&nbsp";
	  			listHtml += "<button class='btn btn-warning btn-sm' onclick='goDelete(" + obj.idx + ")'>삭제</button>";
	  			listHtml += "</td>";
	  			listHtml += "</tr>";
  			});
  			
  			listHtml += "<tr>";
  			listHtml += "<td colspan='5'>";
  			listHtml += "<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>";
  			listHtml += "</td>";
  			listHtml += "</tr>";
  			listHtml += "</table>";
  			$("#view").html(listHtml);
  			
  			$("#view").css("display", "block");	 //감추고
  			$("#wform").css("display", "none"); //보이고
	}
  	function goForm() {
		$("#view").css("display", "none");	 //감추고
		$("#wform").css("display", "block"); //보이고
	}
  	
  	function goList() {
		$("#view").css("display", "block");	 //감추고
		$("#wform").css("display", "none"); //보이고
	}
  	
  	function goInsert() {
		//var title = $("#title").val();
		//var content = $("#content").val();
		//var writer = $("#writer").val();
		
		var fData = $("#frm").serialize();
		
		$.ajax({
			url: "boardInsert.do",
			type: "post",
			data: fData,
			success: loadList, 
			error: function () {
				alert("error");
			},
		});
		
		// 폼 초기화
		//$("#title").val("");
		//$("#content").val("");
		//$("#writer").val("");
		
		$("#fclear").trigger("click");
	}
  	
  	function goContent(idx) { // idx=11, 12, 13...
  	
  		if($("#c" + idx).css("display")=="none"){
  			$.ajax({
  				url: "boardContent.do",
  				type: "get",
  				data: {"idx":idx},
  				dataType: "json",
  				success: function (data) {	// data={"content":~~} JSON형태로 날라오므로 그중에서 content만 필요하다.
  					$("#ta"+idx).val(data.content);
  				}, 
  				error: function () {
  					alert("error");
  				}
  			});
  			$("#c" + idx).css("display", "table-row");	//보이게
  			$("#ta"+idx).attr("readonly", true);
  		}else{
  			$("#c" + idx).css("display", "none");			//안보이게
  			
  			$.ajax({	// 조회수증가
  				url: "boardCount.do",
  				type: "get",
  				data: {"idx":idx},
  				dataType: "json",
  				success: function (data) {	// data={"content":~~} JSON형태로 날라오므로 그중에서 content만 필요하다.
  					console.log('data: ', data);
  					console.log('data.count: ', data.count);
  					$("#cnt"+idx).text(data.count);
  				}, 
  				error: function () {
  					alert("error");
  				}
  			});
  		}
	}
  	
  	function goDelete(idx) {
  		// 서버와 통신 : 게시판 삭제하기
  		/* data파라미터는 서버에서 받은 JSON 데이터이다. */
  		$.ajax({
  			url: "boardDelete.do",
  			type: "get",
  			data: {"idx": idx},
  			success: loadList, /* <- 콜백함수 */
  			error: function(){
				alert("error");
  			}
  		});
	}
	
	function goUpdateForm(idx) { //idx=10, 11, 12...
  		// 서버와 통신 : 게시판 수정하기
  		/* data파라미터는 서버에서 받은 JSON 데이터이다. */
  		$("#ta"+idx).attr("readonly", false); //1. textarea의 readonly속성을 제거
  		
  		//2. 제목을 수정할 수 있는 inputBox로 바꿔준다.
  		var title = $("#t"+idx).text();
  		var newInput = "<input type='text' id='nt"+idx+"' class='form-control' value='"+title+"'/>"
  		$("#t"+idx).html(newInput);
  		
  		//3. 수정화면버튼을 수정버튼으로 바꿔준다.
  		var newButton="<button class='btn btn-primary btn-sm' onclick='goUpdate("+idx+")'>수정</button>";
  		$("#ub"+idx).html(newButton);
	}
	
	function goUpdate(idx) {
		var title = $("#nt"+idx).val();
		var content = $("#ta"+idx).val();
		$.ajax({
  			url: "boardUpdate.do",
  			type: "post",
  			data: {"idx":idx, "title": title, "content":content},
  			success: loadList, /* <- 콜백함수 */
  			error: function(){
				alert("error");
  			}
  		});
	}
  </script>
</head>
<body>
 
<div class="container">
  <h2>Spring MVC02</h2>
  <div class="panel panel-default">
    <div class="panel-heading">BOARD</div>
    <div class="panel-body" id="view">Panel Content</div>
    <div class="panel-body" id="wform" style="display: none;">
		<form id="frm">
			<table class="table">
				<tr>
					<td>제목</td>
					<td><input type="text" id="title" name="title" class="form-control" /></td>
				</tr>
				<tr>
					<td>내용</td>
					<td><textarea rows="7" class="form-control" id="content" name="content"></textarea></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td><input type="text" id="writer" name="writer" class="form-control" /></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
						<button type="reset" class="btn btn-warning btn-sm" id="fclear">취소</button>
						<button type="button" class="btn btn-info btn-sm" onclick='goList()'>목록</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
    <div class="panel-footer">인프런_스프1탄_이정수</div>
  </div>
</div>

</body>
</html>
