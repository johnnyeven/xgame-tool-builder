package com.xgame.tools.mapbuilder.plugins.map.view
{
	import com.xgame.tools.mapbuilder.editor.Editor;
	import com.xgame.tools.mapbuilder.plugins.IPopUpPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.layouts.BasicLayout;
	import spark.layouts.HorizontalLayout;
	
	public class WindowCreateProject extends TitleWindow implements IPopUpPanel
	{
		public var iptName: TextInput;
		public var iptPath: TextInput;
		public var btnCreate: Button;
		public var btnCancel: Button;
		
		public function WindowCreateProject()
		{
			super();
			
			title = "新建项目";
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
			formItem.label = "项目名称";
			
			form.addElement(formItem);
			
			iptName = new TextInput();
			iptName.percentWidth = 100;
			
			formItem.addElement(iptName);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 40;
			formItem.label = "项目路径";
			formItem.layout = new HorizontalLayout();
			
			form.addElement(formItem);
			
			iptPath = new TextInput();
			iptPath.width = 200;
			iptPath.editable = false;
			
			formItem.addElement(iptPath);
			
			var btnBrowse: Button = new Button();
			btnBrowse.label = "浏览";
			btnBrowse.addEventListener(MouseEvent.CLICK, onBtnBrowseClick);
			
			formItem.addElement(btnBrowse);
			
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
			PopUpManager.addPopUp(this, Editor.instance.main, true);
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
			if(iptName.text != "" && iptPath.text != "")
			{
				Editor.instance.createProject(iptName.text, iptPath.text);
				close();
			}
			else
			{
				Alert.show("名称或者路径不能为空", "错误", Alert.OK, Editor.instance.main);
			}
		}
		
		private function onBtnBrowseClick(evt: MouseEvent): void
		{
			var _file: File = new File();
			_file.addEventListener(Event.SELECT, onDirSelected);
			_file.browseForDirectory("选择目录");
		}
		
		private function onDirSelected(evt: Event): void
		{
			iptPath.text = (evt.target as File).nativePath;
		}
	}
}