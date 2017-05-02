<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<#include "/inc/meta.ftl"/>
<#include "/inc/easyui.ftl"/>
<link rel="stylesheet" href="${static}/js/zTree/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${static}/js/zTree/jquery.ztree.all-3.5.min.js"></script>
<#assign requestURI = springMacroRequestContext.getRequestUri() />
<script type="text/javascript" charset="UTF-8">
	var editRow;
	var datagrid;
	var roleDialog;
	var roleForm;
	var restree;
	
	var resdialog;
	var expandAllFlg = true;
	var checkAllTrueOrFalseFlg = true;
	var setting;
	$(function() {
		setting = {
			check: {
				enable: true,
				dblClickExpand: false
			},view: {
				fontCss: getFontCss
			},callback: {
				onClick: onClick
			}
		};
		roleForm = $('#roleForm').form();
		roleDialog = $('#roleDialog001').dialog({
			modal : true,
			title : '角色信息',
			closed:true,
			width:800,
			height:450,
			buttons : [ {
				text : '确定',
				style:'text-align:center',
				handler : function() {
				/*  var checked = $('#resourcesList').combotree('tree').tree('getChecked',['checked','indeterminate']); 
					//通过js来遍历选中节点的父节点
					for(var i=0;i<checked.length;i++){
						getParentNodeId("resourcesList",checked[i])
					}
					var val = $('#resourcesList').combotree('getValues');
					var str ="";
					if(val.length>0){
						for(var j=0;j<nodeIds.length;j++){
							val.push(nodeIds[j]);
						}
						val=unique(val)
						str+=val[0];
						for(var i=1;i<val.length;i++){
							str+=","+val[i];
						}
					}
					$("#thisResourcesId").val(str);
				*/
					var ids = "";
					var treeObj = $.fn.zTree.getZTreeObj("treeDemo2");
					var nodes = treeObj.getCheckedNodes(true);
					//alert(nodes.length);
					for(var i=0;i<nodes.length;i++){
						ids+=i==0?nodes[i].id:","+nodes[i].id;
					}
					//$("#thisResourcesId").val(ids);
					var formData={
						"text":$('[name=text]').val(),
						"descript":$('[name=descript]').val(),
						"seq":$('[name=seq]').val()
					}
					//拥有菜单
					var menus=[];
					if(ids){
						var menuIds=ids.split(",");
						for(var i=0;i<menuIds.length;i++){
							menus.push({"id":menuIds[i]});
						}
					}
					/*//获取选中机构节点
						var idsOrg = "";
						var treeObjOrg = $.fn.zTree.getZTreeObj("orgTree");
						var nodesOrg = treeObjOrg.getCheckedNodes(true);
						
						for(var i=0;i<nodesOrg.length;i++){
							idsOrg+=i==0?nodesOrg[i].id:","+nodesOrg[i].id;
							
						}
						formData.orgIds=idsOrg;
					*/	
					formData.menus=menus;
				
					if (roleForm.form('validate')) {
						var url="${ctx}/role/add";
						var msg="新增";
						if ($("#roleForm").find('[name=id]').val() != '') {
							url='${ctx}/role/edit';
							formData.id=$('[name=id]').val();
							msg="修改";
						}
						sy.ajaxSubmit({
							url:url, 
							data:JSON.stringify(formData),
							contentType:"application/json",
				 			success:function(result){
								if (result.success) {
									roleDialog.dialog('close');
									$.messager.alert('角色'+msg,"保存成功");
									datagrid.datagrid('reload');
								}else{
									$.messager.alert('角色'+msg,"保存失败");
								}
							}
						});
					}
				}
			}
		]}).dialog('close');
	datagrid = $('#datagrid').datagrid({
		url : '${ctx}/role/treegrid',
		rownumbers:true,
		singleSelect:true,
		title : '',
		iconCls : 'icon-save',
		fit : true,
		fitColumns : true,
		nowrap : false,
		
		animate : false,
		border : false,
		idField : 'id',
		treeField : 'text',
		frozenColumns : [ [{
			title : 'id',
			field : 'id',
			width : 50,
			hidden : true
		}, {
			field : 'text',
			title : '角色名称',
			width : 200,
			editor : {
				type : 'validatebox',
				options : {
					required : true
				}
			}
		} ] ],
		columns : [ [{
			field : 'descript',
			title : '描述',
			width : 200,
			editor : {
				type : 'text'
			}
		}, {
			field : 'parentText',
			title : '上级角色',
			width : 80,
			hidden : true
		}, {
			field : 'createOrg',
			title : '创建机构',
			width : 100,
			formatter:function(value,row){
				if(value){
					return value.orgName;
				}
				return "";
			}
		},
		{
			field : 'seq',
			title : '排序',
			width : 50,
			editor : {
				type : 'numberbox',
				options : {
					min : 0,
					max : 999,
					required : true
				}
			}
		},
		{
			field : '1',
			title : '操作',
			width : 150,
			formatter:function(value,row){
					//var org=row.organization;
					//var orgId="";
					//if(org){
					//	orgId=org.id;
					//}
					var str = "{id:\""+row.id+"\",text:\""+row.text+"\",descript:\""+row.descript+"\",seq:\""+row.seq+"\",resourcesText:\""+row.resourcesText+"\",resourcesId:\""+row.resourcesId+"\"}";
					var res = "{id:\""+row.id+"\"}";
					var btnHtml="";
					<#if GeneralMethod.checkButton(requestURI,"icon-edit")>
						btnHtml="<a href='javascript:edit("+str+");' plain='true'  iconcls='icon-edit' class='easyui-linkbutton l-btn l-btn-plain'><span class='l-btn-left'><span class='l-btn-text icon-edit' style='padding-left: 20px;'>编辑</span></span></a>";
					</#if>
					<#if GeneralMethod.checkButton(requestURI,"icon-remove")>
						btnHtml+="<a href='javascript:remove();' plain='true'  iconcls='icon-remove' class='easyui-linkbutton l-btn l-btn-plain'><span class='l-btn-left'><span class='l-btn-text icon-remove' style='padding-left: 20px;'>删除</span></span></a>";
					</#if>
					<#if GeneralMethod.checkButton(requestURI,"icon-search")>
						btnHtml+="<a href ='javascript:showResources("+res+")' iconcls='icon-search' class='easyui-linkbutton l-btn l-btn-plain' plain='true'><span class='l-btn-left'><span class='l-btn-text icon-search' style='padding-left: 20px;'>查看菜单</span></span></a>";
					</#if>
					return btnHtml; 
			}
		} ] ],
		onContextMenu : function(e, row) {
			e.preventDefault();
			$(this).datagrid('unselectAll');
			$(this).datagrid('select', row.id);
		},
		onLoadSuccess : function(row, data) {
			var t = $(this);
			if (data) {
				$(data).each(function(index, d) {
					if (this.state == 'closed') {
						t.datagrid('expandAll');
					}
				});
			}
		}
		});
		
	//loadOrgsTree();
	
	});
	//加载菜单树
	function loadMenusTree(id){
		$.ajax({
			url:"${ctx}/role/getMenusByPid",
			type:"post",
			data:{roleId:id,parentId:0},
			dataType:"text",
			success:function(data1, textStatus){
				var zNodes = eval('('+data1+')');
				$.fn.zTree.init($("#treeDemo2"), setting, zNodes);
				$("#role_name").focus();
			},
			error:function(){
				alert("error");
			}
		});
			//全部展开	
		$("#expandOrCollapseAllBtn").bind("click", {type:"expandOrCollapse"}, expandNode);
		$("#checkAllTrueOrFalse").bind("click", {type:"checkAllTrueOrFalse"}, expandNode);
	}
	function onClick(e,treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo2");
		zTree.expandNode(treeNode);
	}
			
	function getFontCss(treeId, treeNode) {
		return (!!treeNode.highlight) ? {color:"#A60000", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};
	}
	function expandNode(e) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo2"),
		type = e.data.type,
		nodes = zTree.getSelectedNodes();
		if(type == "expandAll") {
			zTree.expandAll(true);
		}else if (type == "collapseAll") {
			zTree.expandAll(false);
		}else if(type == "expandOrCollapse") {
			zTree.expandAll(expandAllFlg);
			expandAllFlg = !expandAllFlg;
		}else if (type == "checkAllTrueOrFalse") {
			zTree.checkAllNodes(checkAllTrueOrFalseFlg);
			checkAllTrueOrFalseFlg = !checkAllTrueOrFalseFlg;
		}else{
			if(type.indexOf("All")<0 && nodes.length == 0) {
				alert("请先选择一个父节点");
			}
			var callbackFlag = $("#callbackTrigger").attr("checked");
			for(var i=0, l=nodes.length; i<l; i++) {
				zTree.setting.view.fontCss = {};
				if(type == "expand") {
					zTree.expandNode(nodes[i], true, null, null, callbackFlag);
				}else if(type == "collapse") {
					zTree.expandNode(nodes[i], false, null, null, callbackFlag);
				}else if(type == "toggle") {
					zTree.expandNode(nodes[i], null, null, null, callbackFlag);
				}else if(type == "expandSon") {
					zTree.expandNode(nodes[i], true, true, null, callbackFlag);
				}else if(type == "collapseSon") {
					zTree.expandNode(nodes[i], false, true, null, callbackFlag);
				}
			}
		}
	}
	function showResources(row){
		var id = row.id;
		resdialog = $("#showRes").show().dialog({
			modal : true,
			title : '菜单信息',
			width:300,
			height:400,
			shadow:false
		});
		
		restree = $('#restree').tree({
			url : '${ctx}/role/showTree/'+id,
			animate : false,
			lines : !sy.isLessThanIe8(),
			onLoadSuccess : function(node, data) {
				var t = $(this);
				if (data) {
					$(data).each(function(index, d) {
						if (this.state == 'closed') {
							t.tree('expandAll');
						}
					});
				}
			}
		});
	}
	function edit() {
		if (editRow) {
		    myMessage("您没有结束之前编辑的数据，请先保存或取消编辑！");
		} else {
			var node = datagrid.datagrid('getSelected');
			if (node && node.id) {
				datagrid.datagrid('beginEdit', node.id);
				editRow = node;
				
				
				
			}
			
			
			
		}
		
		
	}
	function edit(row){
	
			//loadOrgsTree();
			
			roleDialog.dialog('open');
			roleForm.form('clear');
			/*$("#resourcesList").combotree({
				url : '${ctx}/role/showTree4check/'+row.id,
				animate : false,
				lines : !sy.isLessThanIe8(),
				onLoadSuccess : function(node, data) {
					var t = $(this);
					if (data) {
						$(data).each(function(index, d) {
							if (this.state == 'closed') {
								t.tree('expandAll');
							}
							if(this.children){
								initCheckedState("resourcesList",this)
							}
						});
					}
				}
			});*/
			
			var str = row.resourcesId+"";
			var strs= new Array(); //定义一数组
			if("null"!=str && null!=str && ""!=str){
				strs=str.split(","); //字符分割 
			} else{
				strs="";
			}
			var descript="";
			if("null"!=row.descript && null!= row.descript&& ""!=row.descript){
			  descript=row.descript;
			}else{
				descript="";
			} 
			//alert(descript+","+strs);
			roleForm.form('load', {
				id:row.id,
				text:row.text,
				descript:descript,
				seq : row.seq,
				resourcesText:strs
			});
			loadMenusTree($("#roleId").val());
	}
	function append(){
	//loadOrgsTree();
	
		roleDialog.dialog('open');
		roleForm.form('clear');
		/*$("#resourcesList").combotree({
			url : '${ctx}/role/treeAll',
			animate : false,
			lines : !sy.isLessThanIe8(),
			onLoadSuccess : function(node, data) {
				var t = $(this);
				if (data) {
					$(data).each(function(index, d) {
						if (this.state == 'closed') {
							t.tree('expandAll');
						}
					});
				}
			}
		});*/
		//alert($("#roleId").val());
		loadMenusTree($("#roleId").val());
	}
	function remove() {
		var node = datagrid.datagrid('getSelected');
		var ids = new Array();
		ids.push(node.id);	
		if (node) {
			$.messager.confirm('询问', '您确定要删除【' + node.text + '】角色？', function(b) {
				if (b) {
					$.ajax({
						url : '${ctx}/role/del?ids='+node.id,
						cache : false,
						dataType : "json",
						success : function(r) {
							if (r.success) {
								datagrid.datagrid('reload');
								myMessage(r.msg);
								editRow = undefined;
							} else {
							    myMessage("删除角色失败!");
							}
						}
					});
				}
			});
		}
	}
		/*提示消息弹出框函数*/
	function myMessage(mg)
	{
	   $.messager.alert('提示',mg);
	}
	var nodeIds=[];
	function getParentNodeId(treeId,node){
		var p= $('#'+treeId).combotree('tree').tree('getParent',node.target);
		if(p){
			 nodeIds.push(p.id);
			 var p1=$('#'+treeId).combotree('tree').tree('getParent',p.target);
			 if(p1){
			 	getParentNodeId(treeId,p)
			 }
		}
	}
	function unique(arr) {
		var result = [], isRepeated;
		for (var i = 0;i<arr.length; i++) {
			isRepeated = false;
			for (var j = 0;j < result.length; j++) {
				if (arr[i] == result[j]) {   
					isRepeated = true;
					break;
				}
			}
			if (!isRepeated) {
				result.push(arr[i]);
			}
		}
		return result;
	}
	//初始化权限菜单的选中状态
	function initCheckedState(treeId,node){
		var nodes=node.children;
		if(nodes){
			for(var i=0;i<nodes.length;i++){
				if(nodes[i]){
					if(!nodes[i].children){
						
						if(nodes[i].attributes.check){
							var c=$("#"+treeId).combotree("tree").tree("find",nodes[i].id);
							$("#"+treeId).combotree("tree").tree("check",c.target);
						}
					}else{
						initCheckedState(treeId,nodes[i]);
					}
				}
			}
		}
	}
	
</script>

<script type="text/javascript" charset="UTF-8">
	var $orgTree;
	
	
	//加载机构树
	function loadOrgsTree(){
	
		
		var treeNodes;
		var roleId;
		var node = datagrid.datagrid('getSelected');
		var roleIdTem='';
		if(node!=undefined || node!=null){
			roleIdTem=node.id;
		}
		
		var settingOrg = {  
		    isSimpleData : true,              //数据是否采用简单 Array 格式，默认false  
		    treeNodeKey : "id",               //在isSimpleData格式下，当前节点id属性  
		    showLine : true, 
		    checkable : true,
		    check: {
				enable: true,
				dblClickExpand: false
			},view: {
				fontCss: getFontCss
			},callback: {
				onClick: onClickOrg
			}              
		};  
		settingOrg.check.chkboxType = { "Y" : "s", "N" : "s" };
  		//settingOrg.check.enable = false;
	    $.ajax({  
	        async : false,  
	        cache:false,  
	        type: 'POST',
	        data:{
	        	id:1,
	        	roleId:roleIdTem
	        },  
	        dataType : "text",  
	        url: '${ctx}/role/getOrgsbyRoleId',//请求的action路径  
	        error: function () {
	            alert('请求失败');  
	        },  
	        success:function(data){ //请求成功后处理函数。    
	            treeNodes = eval('('+data+')');;   //把后台封装好的简单Json格式赋给treeNodes  
				$.fn.zTree.init($("#orgTree"), settingOrg, treeNodes);
			/*		
					var zTree = $.fn.zTree.getZTreeObj("orgTree");
				  	//var allNodes= zTree.getNodes();
				  	var allNodes = zTree.transformToArray(zTree.getNodes());
			
				   for (var i=0; i < allNodes.length; i++) {
				   		if(allNodes[i].checked == true){
				   			allNodes[i].checked=false;
				   		}else{
				   			allNodes[i].chkDisabled=true;
				   		}
				   		zTree.updateNode(allNodes[i]);
					}	
			*/				
	        }  
	    });  
	 
	}
	
	function onClickOrg(e,treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("orgTree");
		zTree.expandNode(treeNode);
		
	}
	
</script>

</head>
<body class="easyui-layout" fit="true">
	<div region="center" border="false" style="overflow: hidden;">
		<div  class="search_table datagrid-toolbar" style="display: block;">
			<table>
				<tr>
					<td>
					<#if GeneralMethod.checkButton(requestURI,"icon-add")>
						<a href="javascript:append();" class="easyui-linkbutton" iconCls="icon-add">新 增</a>
					</#if>
					</td>
				</tr>
			</table>
		</div>
		<table id="datagrid"></table>
	</div>
	<div id="roleDialog001" >
		<form id="roleForm" method="post">
			<table class="basic basic_dialog">
				<tr>
					<th style="display:none;">角色ID</th>
					<td style="display:none;"><input name="id" id="roleId" readonly="readonly" /></td>
				</tr>
				<tr>
					<th>角色名称：</th>
					<td><input name="text" class="easyui-textbox validatebox "  style="width:170px; height:26px;" required="true"  validType="length[1,100]" /></td>
				</tr>
				<tr>
					<th>描&#12288;&#12288;述：</th>
					<td><input name="descript" class="easyui-textbox validatebox "  style="width:170px; height:26px;" validType="length[0,100]" /></td>
				</tr>
				<tr>
					<th>排&#12288;&#12288;序：</th>
					<td><input name="seq" class="easyui-textbox validatebox "  style="width:170px; height:26px;" required="true" /></td>
				</tr>
				<!--<tr>
					<th >权限机构：</th>
					<td style="width:60%;">
						<a href="javascript:chooseOrg();" class="easyui-linkbutton" >机构选择</a>
							<ul id="orgTree" class="ztree" style="width: 230px;"></ul>
					</td>
				</tr>
	-->
				<tr>
					<th>拥有菜单：</th>
					<td style="width:60%;">
							<div id="optionDiv">
								[<a id="expandOrCollapseAllBtn" style="cursor:pointer;" title="展开/折叠全部资源" onclick="return false;">展开/折叠</a>]
								[<a id="checkAllTrueOrFalse" style="cursor:pointer;" title="全选/全不选" onclick="return false;">全选/全不选</a>]
							</div>
							<ul id="treeDemo2" class="ztree"></ul>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div  id="showRes" class="easyui-tree" style="display: none;overflow: auto;background:#FFFFFF;height:300;">
		<div id="restree"></div>
	</div>
	
	<div  id="orgDialog" class="easyui-tree" style="display: none;overflow: auto;background:#FFFFFF;height:300;">
		<ul id="orgTree2" class="ztree" style="width: 230px;"></ul>
	</div>
</body>
</html>