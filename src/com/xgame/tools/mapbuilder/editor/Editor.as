package com.xgame.tools.mapbuilder.editor
{
	import com.xgame.tools.mapbuilder.common.Document;
	import com.xgame.tools.mapbuilder.common.Project;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateDirectory;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateDocument;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateProject;
	import com.xgame.tools.mapbuilder.event.EditorEvent;
	import com.xgame.tools.mapbuilder.plugins.IEditor;
	
	import flash.errors.IllegalOperationError;
	
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.Module;
	import mx.modules.ModuleManager;
	
	public class Editor
	{
		private static var _instance: Editor;
		private static var _allowInstance: Boolean = false;
		
		private var _i: IModuleInfo;
		private var _m: IEditor;
		private var _currentSelectedDoc: Document;
		
		private var _main: Main;
		private var _winNewProject: WindowCreateProject;
		private var _winNewDocument: WindowCreateDocument;
		private var _winCreateDirectory: WindowCreateDirectory;
		
		public function Editor(main: Main)
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
			
			_main = main;
			
			_winNewProject = new WindowCreateProject();
			_winNewDocument = new WindowCreateDocument();
			_winCreateDirectory = new WindowCreateDirectory();
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
		
		public function showWinCreateDirectory(): void
		{
			_winCreateDirectory.show();
		}
		
		public function createProject(name: String, path: String): void
		{
			Project.instance.init(name, path);
		}
		
		public function createDocument(doc: Document): void
		{
			var current: XML = XML(_main.treeProjectFile.selectedItem);
			if(current != null && current.@isBranch == "true")
			{
				var id: String = current.@id;
				doc.parent = FileManager.instance.getDocument(id);
			}
			
			FileManager.instance.addDocument(doc);
			Project.instance.rebuildXML();
			rebuildFileTree(Project.instance.config.file);
		}
		
		public function createEditor(doc: Document): void
		{
			_currentSelectedDoc = doc;
			
			if(_m == null)
			{
				_i = ModuleManager.getModule("com/xgame/tools/mapbuilder/plugins/map/MapEditor.swf");
				_i.addEventListener(ModuleEvent.READY, onModuleReady);
				_i.load();
			}
			else
			{
				if(_currentSelectedDoc != null)
				{
					_m.addDocument(_currentSelectedDoc);
				}
			}
		}
		
		private function onModuleReady(evt: ModuleEvent): void
		{
			_m = _i.factory.create() as IEditor;
			_m.addEventListener(EditorEvent.ITEM_CLICK, onEditorItemClick);
			
			_main.mainStage.addElement(_m);
			
			if(_currentSelectedDoc != null)
			{
				_m.addDocument(_currentSelectedDoc);
			}
		}
		
		private function onEditorItemClick(evt: EditorEvent): void
		{
			var doc: Document = evt.document;
			var type: String = evt.targetType;
		}

		public function get main():Main
		{
			return _main;
		}

	}
}