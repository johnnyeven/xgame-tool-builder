package com.xgame.tools.builder.plugins.map.view
{
	import com.xgame.tools.builder.common.EditorImpl;
	import com.xgame.tools.builder.plugins.map.common.MapDocument;
	import com.xgame.tools.builder.plugins.map.common.MapEditor;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.layouts.BasicLayout;
	
	public class WindowCreateDirectory extends TitleWindow
	{
		public var iptId: TextInput;
		public var iptName: TextInput;
		public var btnCreate: Button;
		public var btnCancel: Button;
		
		public function WindowCreateDirectory()
		{
			super();
			
			title = "新建文件夹";
			width = 400;
			height = 200;
			
			var form: Form = new Form();
			form.percentWidth = 100;
			form.percentHeight = 100;
			form.layout = new BasicLayout();
			addElement(form);
			
			var formItem: FormItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 0;
			formItem.label = "文件夹编号";
			
			form.addElement(formItem);
			
			iptId = new TextInput();
			iptId.percentWidth = 100;
			
			formItem.addElement(iptId);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 40;
			formItem.label = "文件夹名称";
			
			form.addElement(formItem);
			
			iptName = new TextInput();
			iptName.percentWidth = 100;
			
			formItem.addElement(iptName);
			
			btnCreate = new Button();
			btnCreate.left = 50;
			btnCreate.bottom = 20;
			btnCreate.width = 100;
			btnCreate.height = 30;
			btnCreate.label = "创建";
			btnCreate.addEventListener(MouseEvent.CLICK, onBtnCreateClick);
			
			form.addElement(btnCreate);
			
			btnCancel = new Button();
			btnCancel.right = 50;
			btnCancel.bottom = 20;
			btnCancel.width = 100;
			btnCancel.height = 30;
			btnCancel.label = "取消";
			btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
			
			form.addElement(btnCancel);
			
			addEventListener(CloseEvent.CLOSE, onWinClose);
		}
		
		public function show(): void
		{
			PopUpManager.addPopUp(this, EditorImpl.instance.main as DisplayObject, true);
			PopUpManager.centerPopUp(this);
		}
		
		public function close(): void
		{
			PopUpManager.removePopUp(this);
		}
		
		private function onWinClose(evt: CloseEvent): void
		{
			close();
		}
		
		private function onBtnCancelClick(evt: MouseEvent): void
		{
			close();
		}
		
		private function onBtnCreateClick(evt: MouseEvent): void
		{
			if(iptId.text != "" && iptName.text != "")
			{
				var _doc: MapDocument = new MapDocument(iptId.text, true);
				_doc.name = iptName.text;
				
				EditorImpl.instance.createDocument(_doc);
				close();
			}
			else
			{
				Alert.show("所有表单必填", "错误", Alert.OK);
			}
		}
	}
}