package com.xgame.tools.builder.common
{
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IEditorManager;
	
	import flash.errors.IllegalOperationError;
	
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.Tree;
	
	public class EditorImpl implements IEditorManager
	{
		private static var _instance: EditorImpl;
		private static var _allowInstance: Boolean = false;
		
		private var impl: IEditorManager;
		private var _main: Main;
		
		public function EditorImpl(main: Main)
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
			
			_main = main;
		}
		
		public static function init(main: Main): EditorImpl
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new EditorImpl(main);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): EditorImpl
		{
			return _instance;
		}
		
		public function get treeProjectFile(): Tree
		{
			return _main.treeProjectFile;
		}
		
		public function get panelFile(): Panel
		{
			return _main.panelFile;
		}
		
		public function get mainStage(): HBox
		{
			return _main.mainStage;
		}
		
		public function get panelProperty(): Panel
		{
			return _main.panelProperty;
		}
		
		public function get main():Main
		{
			return _main;
		}
		
		public function showWinNewProject():void
		{
			impl.showWinNewProject();
		}
		
		public function showWinNewDocument():void
		{
			impl.showWinNewDocument();
		}
		
		public function showWinCreateDirectory():void
		{
			impl.showWinCreateDirectory();
		}
		
		public function createProject(name:String, path:String):void
		{
			impl.createProject(name, path);
		}
		
		public function createDocument(doc:IDocument):void
		{
			impl.createDocument(doc);
		}
		
		public function createEditor(doc:IDocument):void
		{
			impl.createEditor(doc);
		}
		
		public function rebuildFileTree(config:XMLList):void
		{
			impl.rebuildFileTree(config);
		}
	}
}