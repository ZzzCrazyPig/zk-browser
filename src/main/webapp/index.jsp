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
<script src="js/jquery-dateFormat.min.js"></script>
</head>

<body>
	<nav class="navbar navbar-success">
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
								<button id="listZkPathBtn" class="btn btn-primary">search</button>
							</span>
						</div>
					</div>
					<div id="alertArea" class="alert alert-danger" hidden>error</div>
					<ol id="curZkPath" class="breadcrumb">
						<li class="active">/</li>
					</ol>
					<br />
					<table id="dirListTable" class="table">
						<tr><td><a href="#">...</a></td></tr> <!-- return back -->
					</table>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
	
		$(document).ready(function() {
			
			var zkPathInput = $('#zkPathInput');
			var listZkPathBtn = $('#listZkPathBtn');
			var alertArea = $('#alertArea');
			var curZkPath = $('#curZkPath');
			var dirListTable = $('#dirListTable');
			var curPath = ["/"];
			
			zkPathInput.bind('keypress', function(event){
				if(event.keyCode == "13") {
					listZkPathBtn.click();
				}
			});
			
			listZkPathBtn.click(function(){
				var path = zkPathInput.val();
				path = path.replace(/\s/g, "");
				ls(path, processCurPath);
			});
			
			curZkPath.on('click', 'a.jumpInto', function(e){
				var index = $(this).parent().index();
				jumpInto(index);
			});
			
			dirListTable.on('click', 'a.cdUp', function(e){
				if(curPath.length == 1) { 
					return;
				}
				jumpInto(curPath.length - 2);
			});
			
			dirListTable.on('click', 'a.cdInto', function(e){
				var cdDir = $(this).text();
				var lastDir = curPath[curPath.length - 1];
				curPath.push(cdDir);
				var lastChild = curZkPath.children().last();
				lastChild.html('<a class="jumpInto" href="javascript:void(0);">' + lastDir + '</a>');
				curZkPath.append('<li class="active">' + cdDir + "</li>");
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
				var len = curPath.length;
				for(var i = index + 1; i < len; i++) {
					curPath.pop();
					curZkPath.children().last().remove();
				}
				var lastChild = curZkPath.children().last();
				lastChild.addClass('active')
							.text(curPath[index])
							.children()
							.remove();
				var path = getPath(curPath);
				ls(path);
			};
			
			var showErrMsg = function(errMsg) {
				alertArea.html(errMsg).show().delay(3000).hide(0);
			};
			
			var processCurPath = function(path) {
				curPath = [];
				curPath.push("/");
				if(path != "/") {
					var splitArr = path.split("/");
					splitArr.shift();
					curPath = curPath.concat(splitArr);
				}
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
			
			var ls = function(path, callback) {
				$.get('ls', {
					path: path
				},function(resp){
					if(!resp.success) {
						showErrMsg(resp.errorMessage);
						return;
					}
					showDirList(resp.row);
					if(callback != null && typeof callback === 'function') {
						callback(path);
					}
				});
			};
			
			var _get = function(path) {
				$.get('get', {
					path: path
				}, function(resp){
					if(!resp.success) {
						showErrMsg(resp.errorMessage);
						return;
					}
					BootstrapDialog.show({
						title: 'zk node info',
						type: 'type-default',
						message: function(dialog) {
							/* cZxid = 0x10000004f
							ctime = Mon Oct 17 18:20:20 CST 2016
							mZxid = 0x100000052
							mtime = Mon Oct 17 18:20:20 CST 2016
							pZxid = 0x10000004f
							cversion = 0
							dataVersion = 3
							aclVersion = 0
							ephemeralOwner = 0x0
							dataLength = 75
							numChildren = 0 */
							
							var row = resp.row;
							var data = row.dataAsString;
							var czxid = row.stat.czxid;
							var ctime = row.stat.ctime;
							var mzxid = row.stat.mzxid;
							var mtime = row.stat.mtime;
							var pzxid = row.stat.pzxid;
							var cversion = row.stat.cversion;
							var version = row.stat.version;
							var aversion = row.stat.aversion;
							var ephemeralOwner = row.stat.ephemeralOwner;
							var dataLength = row.stat.dataLength;
							var numChildren = row.stat.numChildren;
							
							var sdf = "yyyy-MM-dd HH:mm:ss.SSS";
							
							var $message = $('<div style="word-wrap:break-word;word-break:break-all;"></div>');
							$message.append('<p>' + data + '</p>')
									.append('<br />')
									.append('<p> cZxid = ' + czxid + '</p>')
									.append('<p> ctime = ' + $.format.date(ctime, sdf) + '</p>')
									.append('<p> mZxid = ' + mzxid + '</p>')
									.append('<p> mtime = ' + $.format.date(mtime, sdf) + '</p>')
									.append('<p> pZxid = ' + pzxid + '</p>')
									.append('<p> cversion = ' + cversion + '</p>')
									.append('<p> dataVersion = ' + version + '</p>')
									.append('<p> aclVersion = ' + aversion + '</p>')
									.append('<p> ephemeralOwner = ' + ephemeralOwner + '</p>')
									.append('<p> dataLength = ' + dataLength + '</p>')
									.append('<p> numChildren = ' + numChildren + '</p>');
							return $message;
						
						}
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
