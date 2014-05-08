package com.xgame.tools.mapbuilder.editor
{
	import com.xgame.tools.mapbuilder.common.Document;
	import com.xgame.tools.mapbuilder.common.ProjectImpl;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateDirectory;
	import com.xgame.tools.mapbuilder.editor.view.WindowCreateDocument;
	import com.xgame.tools.mapbuilder.event.EditorEvent;
	import com.xgame.tools.mapbuilder.plugins.IEditor;
	import com.xgame.tools.mapbuilder.plugins.IFile;
	import com.xgame.tools.mapbuilder.plugins.IPopUpPanel;
	import com.xgame.tools.mapbuilder.plugins.IProperty;
	import com.xgame.tools.mapbuilder.plugins.map.view.WindowCreateProject;
	
	import flash.errors.IllegalOperationError;
	
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.Module;
	import mx.modules.ModuleManager;
	
	public class Editor
	{
		private static var _instance: Editor;
		private static var _allowInstance: Boolean = false;
		
		private var _fileModuleInfo: IModuleInfo;
		private var _fileModule: IFile;
		private var _editorModuleInfo: IModuleInfo;
		private var _editorModule: IEditor;
		private var _propertyModuleInfo: IModuleInfo;
		private var _propertyModule: IProperty;
		private var _currentSelectedDoc: Document;
		
		private var _main: Main;
		private var _winNewProject: IPopUpPanel;
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
			ProjectImpl.instance.init(name, path);
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
			ProjectImpl.instance.rebuildXML();
			rebuildFileTree(ProjectImpl.instance.config.file);
		}
		
		public function createEditor(doc: Document): void
		{
			_currentSelectedDoc = doc;
			
			if(_fileModule == null)
			{
				_fileModuleInfo = ModuleManager.getModule("com/xgame/tools/mapbuilder/plugins/map/MapFileTree.swf");
				_fileModuleInfo.addEventListener(ModuleEvent.READY, onFileModuleReady);
				_fileModuleInfo.load();
			}
			else
			{
				
			}
			
			if(_editorModule == null)
			{
				_editorModuleInfo = ModuleManager.getModule("com/xgame/tools/mapbuilder/plugins/map/MapEditor.swf");
				_editorModuleInfo.addEventListener(ModuleEvent.READY, onEditorModuleReady);
				_editorModuleInfo.load();
			}
			else
			{
				if(_currentSelectedDoc != null)
				{
					_editorModule.addDocument(_currentSelectedDoc);
				}
			}
			
			if(_propertyModule == null)
			{
				_propertyModuleInfo = ModuleManager.getModule("com/xgame/tools/mapbuilder/plugins/map/MapProperty.swf");
				_propertyModuleInfo.addEventListener(ModuleEvent.READY, onPropertyModuleReady);
				_propertyModuleInfo.load();
			}
			else
			{
				
			}
		}
		
		private function onFileModuleReady(evt: ModuleEvent): void
		{
			_fileModule = _fileModuleInfo.factory.create() as IFile;
			
			_main.panelFile.addElement(_fileModule);
		}
		
		private function onEditorModuleReady(evt: ModuleEvent): void
		{
			_editorModule = _editorModuleInfo.factory.create() as IEditor;
			_editorModule.addEventListener(EditorEvent.ITEM_CLICK, onEditorItemClick);
			
			_main.mainStage.addElement(_editorModule);
			
			if(_currentSelectedDoc != null)
			{
				_editorModule.addDocument(_currentSelectedDoc);
			}
		}
		
		private function onPropertyModuleReady(evt: ModuleEvent): void
		{
			_propertyModule = _propertyModuleInfo.factory.create() as IProperty;
			
			_main.panelProperty.addElement(_propertyModule);
		}
		
		private function onEditorItemClick(evt: EditorEvent): void
		{
			var doc: Document = evt.document;
			var type: String = evt.targetType;
			
			_propertyModule.showProperty(type, doc);
		}

		public function get main():Main
		{
			return _main;
		}

	}
}