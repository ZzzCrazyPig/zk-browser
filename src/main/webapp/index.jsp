<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>zk browser</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/bootstrap-theme.min.css" rel="stylesheet">
<link href="css/bootstrap-dialog.min.css" rel="stylesheet">
<link href="css/bootstrap-extend.css" rel="stylesheet">
<link href="css/bootstrap-metro.css" rel="stylesheet">
<link href="css/bootstrap-theme-extend.css" rel="stylesheet">
<!--[if lt IE 9]>
<script src="js/html5shiv.js"></script>
<script src="js/respond.min.js"></script>
<![endif]-->
<script src="js/jquery-1.11.1.min.js"></script>
<script src="js/jquery-ui-1.9.2-min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-dialog.min.js"></script>
</head>

<body>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#sidebar-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a style="font-size: 20px;" class="navbar-brand" href="#"><span>zk
						browser</span></a>
			</div>
		</div>
	</nav>

	<div class="container">
		<div class="row">
			<div id="main-panel">
				<div class="col-md-offset-2 col-md-8">
					<h1>Zookeeper Directory Browser</h1>
					<div class="form-group">
						<div class="input-group">
							<input id="zkPathInput" class="form-control"
								placeholder="please input a zk path">
							<span class="input-group-btn">
								<button id="listZkPathBtn" class="btn btn-default">search</button>
							</span>
						</div>
					</div>
					<ol id="curZkPath" class="breadcrumb">
						<li><a href="#">Home</a></li>
						<li><a href="#">Library</a></li>
						<li class="active">Data</li>
					</ol>
					<br />
					<table id="dirListTable" class="table">
						<tr><td><a href="#">...</a></td></tr> <!-- return back -->
						<tr><td><a href="#">dir1</a></td></tr>
						<tr><td><a href="#">dir1</a></td></tr>
						<tr><td><a href="#">dir1</a></td></tr>
					</table>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
	
		$(document).ready(function() {
			
			var zkPathInput = $('#zkPathInput');
			var curZkPath = $('#curZkPath');
			var dirListTable = $('#dirListTable');
			var curPath = [];
			
			$('#listZkPathBtn').click(function(){
				var path = zkPathInput.val();
				ls(path);
			});
			
			curZkPath.on('click', 'a.jumpInto', function(e){
				var index = $(this).parent().index();
				console.info("index = " + index);
				jumpInto(index);
			});
			
			dirListTable.on('click', 'a.cdUp', function(e){
				console.info("on cdUp, curPath : " + curPath);
				if(curPath.length == 1) { 
					return;
				}
				curPath.pop();
				var path = getPath(curPath);
				console.info("cd up : " + path);
				ls(path);
			});
			
			dirListTable.on('click', 'a.cdInto', function(e){
				console.info("on cdInto, curPath : " + curPath);
				var cdDir = $(this).text();
				curPath.push(cdDir);
				var path = getPath(curPath);
				ls(path);
			});
			
			dirListTable.on('click', 'a.see', function(e){
				var dir = $(this).parent().next().find('a').eq(0).text();
				var tmpPath = [];
				tmpPath = tmpPath.concat(curPath);
				tmpPath.push(dir);
				var path = getPath(tmpPath);
				_get(path);
			});
			
			var jumpInto = function(index) {
				var path = "";
				if(index == 0) {
					path = "/";
				} else {
					for(var i = 1; i <= index; i++) {
						path = path + "/" + curPath[i];
					}
				}
				console.info("will jump into : " + path);
				ls(path);
			};
			
			var processCurPath = function(path) {
				curPath = [];
				curPath.push("/");
				if(path != "/") {
					var splitArr = path.split("/");
					splitArr.shift();
					curPath = curPath.concat(splitArr);
				}
				console.info(curPath);
				// remove all
				curZkPath.children().remove();
				for(var i = 0; i < curPath.length; i++) {
					var tmp = curPath[i];
					if(i == curPath.length - 1) {
						curZkPath.append('<li class="active">' + tmp + '</li>');
					} else {
						curZkPath.append('<li><a class="jumpInto" href="javascript:void(0);">' + tmp + '</a></li>');
					}
				}
			};
			
			var ls = function(path) {
				$.get('ls', {
					path: path
				},function(resp){
					showDirList(resp);
					processCurPath(path);
				});
			};
			
			var _get = function(path) {
				$.get('get', {
					path: path
				}, function(resp){
					// console.info(resp);
					BootstrapDialog.show({
						title: 'zk node info',
						message: "This is the message"
					});
				});
			}
			
			var showDirList = function(dirList) {
				// remove all
				var target = dirListTable;
				target.children().remove();
				
				// add return back link
				target.append('<tr><td><a class="cdUp" href="javascript:void(0);">...</a></td></tr>')
				
				for(var i = 0; i < dirList.length; i++) {
					var dir = dirList[i];
					target.append('<tr><td width="50px;"><a class="see" href="javascript:void(0);"><span class="glyphicon glyphicon-eye-open"></span></a></td><td><a class="cdInto" href="javascript:void(0);">' + dir + '</a></td></tr>')
				}
			};
			
			var getPath = function(pathArr) {
				if(pathArr.length == 1) {
					return "/";
				}
				var path = "";
				for(var i = 1; i < pathArr.length; i++) {
					path = path + "/" + pathArr[i];
				}
				return path;
			};
			
			ls("/");

		});
	</script>
</body>
</html>
