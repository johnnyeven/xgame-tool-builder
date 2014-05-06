package com.xgame.tools.mapbuilder.editor
{
	import com.xgame.tools.mapbuilder.common.Document;
	import com.xgame.tools.mapbuilder.common.Project;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateDocument;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateProject;
	
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	
	public class Editor
	{
		private static var _instance: Editor;
		private static var _allowInstance: Boolean = false;
		
		private var _main: Main;
		private var _winNewProject: WindowCreateProject;
		private var _winNewDocument: WindowCreateDocument;
		
		public function Editor(main: Main)
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
			
			_main = main;
			
			_winNewProject = new WindowCreateProject();
			_winNewDocument = new WindowCreateDocument();
		}
		
		public static function init(main: Main): Editor
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Editor(main);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): Editor
		{
			return _instance;
		}
		
		public function rebuildFileTree(config: XMLList): void
		{
			_main.treeProjectFile.dataProvider = config.elements();
		}
		
		public function showWinNewProject(): void
		{
			_winNewProject.show();
		}
		
		public function showWinNewDocument(): void
		{
			_winNewDocument.show();
		}
		
		public function createProject(name: String, path: String): void
		{
			Project.instance.init(name, path);
		}
		
		public function createDocument(doc: Document): void
		{
			FileManager.instance.fileContainer.push(doc);
			Project.instance.rebuildXML();
			rebuildFileTree(Project.instance.config.file);
		}

		public function get main():Main
		{
			return _main;
		}

	}
}