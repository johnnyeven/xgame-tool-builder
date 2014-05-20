package com.xgame.tools.builder.plugins.map.view
{
	import com.xgame.tools.builder.common.EditorImpl;
	import com.xgame.tools.builder.plugins.map.common.MapDocument;
	import com.xgame.tools.builder.plugins.map.common.MapEditor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.layouts.BasicLayout;
	import spark.layouts.HorizontalLayout;
	
	public class WindowCreateDocument extends TitleWindow
	{
		public var iptId: TextInput;
		public var iptName: TextInput;
		public var iptPath: TextInput;
		public var iptWidth: TextInput;
		public var iptHeight: TextInput;
		public var btnCreate: Button;
		public var btnCancel: Button;
		
		private var _map: BitmapData;
		
		public function WindowCreateDocument()
		{
			super();
			
			title = "新建地图配置";
			width = 400;
			height = 360;
			
			var form: Form = new Form();
			form.percentWidth = 100;
			form.percentHeight = 100;
			form.layout = new BasicLayout();
			addElement(form);
			
			var formItem: FormItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 0;
			formItem.label = "配置编号";
			
			form.addElement(formItem);
			
			iptId = new TextInput();
			iptId.percentWidth = 100;
			
			formItem.addElement(iptId);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 40;
			formItem.label = "配置名称";
			
			form.addElement(formItem);
			
			iptName = new TextInput();
			iptName.percentWidth = 100;
			
			formItem.addElement(iptName);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 80;
			formItem.label = "图片路径";
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
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 120;
			formItem.label = "拷贝到项目路径";
			
			form.addElement(formItem);
			
			var chkCopy: CheckBox = new CheckBox();
			chkCopy.label = "是";
			
			formItem.addElement(chkCopy);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 160;
			formItem.label = "图片宽度";
			
			form.addElement(formItem);
			
			iptWidth = new TextInput();
			
			formItem.addElement(iptWidth);
			
			formItem = new FormItem();
			formItem.percentWidth = 100;
			formItem.x = 0;
			formItem.y = 200;
			formItem.label = "图片高度";
			
			form.addElement(formItem);
			
			iptHeight = new TextInput();
			
			formItem.addElement(iptHeight);
			
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
			if(iptId.text != "" && iptName.text != "" && _map != null && iptWidth.text != "" && iptHeight.text != "")
			{
				var _doc: MapDocument = new MapDocument(iptId.text);
				_doc.name = iptName.text;
				_doc.path = iptPath.text;
				_doc.width = Number(iptWidth.text);
				_doc.height = Number(iptHeight.text);
				_doc.map = _map;
				
				EditorImpl.instance.createDocument(_doc);
				close();
			}
			else
			{
				Alert.show("所有表单必填", "错误", Alert.OK);
			}
		}
		
		private function onBtnBrowseClick(evt: MouseEvent): void
		{
			var _file: File = new File();
			_file.addEventListener(Event.SELECT, onImgSelected);
			
			var _filter: FileFilter = new FileFilter("图片 (*.jpg, *.jpeg, *.png, *.gif)", "*.jpg; *.jpeg; *.png; *.gif");
			_file.browseForOpen("载入图片", [_filter]);
		}
		
		private function onImgSelected(evt: Event): void
		{
			var _file: File = evt.target as File;
			var _fileStream: FileStream = new FileStream();
			var _bytes: ByteArray = new ByteArray();
			iptPath.text = _file.nativePath;
			_fileStream.open(_file, FileMode.READ);
			_fileStream.readBytes(_bytes, 0, _fileStream.bytesAvailable);
			_fileStream.close();
			
			var _loader: Loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoadComplete);
			_loader.loadBytes(_bytes);
		}
		
		private function onImgLoadComplete(evt: Event): void
		{
			var _loaderInfo: LoaderInfo = evt.target as LoaderInfo;
			_map = (_loaderInfo.content as Bitmap).bitmapData;
			
			iptWidth.text = _map.width.toString();
			iptHeight.text = _map.height.toString();
		}

	}
}