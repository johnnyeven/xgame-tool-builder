package com.xgame.tools.builder.plugins.map.common
{
	import com.xgame.tools.builder.common.EditorImpl;
	import com.xgame.tools.builder.common.FileManagerImpl;
	import com.xgame.tools.builder.common.ProjectImpl;
	import com.xgame.tools.builder.event.EditorEvent;
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IEditor;
	import com.xgame.tools.builder.plugins.IEditorManager;
	import com.xgame.tools.builder.plugins.IFile;
	import com.xgame.tools.builder.plugins.IPopUpPanel;
	import com.xgame.tools.builder.plugins.IProperty;
	import com.xgame.tools.builder.plugins.map.view.WindowCreateDirectory;
	import com.xgame.tools.builder.plugins.map.view.WindowCreateDocument;
	import com.xgame.tools.builder.plugins.map.view.WindowCreateProject;
	
	import flash.errors.IllegalOperationError;
	
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.Module;
	import mx.modules.ModuleManager;
	
	public class MapEditor implements IEditorManager
	{
		private var _fileModuleInfo: IModuleInfo;
		private var _fileModule: IFile;
		private var _editorModuleInfo: IModuleInfo;
		private var _editorModule: IEditor;
		private var _propertyModuleInfo: IModuleInfo;
		private var _propertyModule: IProperty;
		private var _currentSelectedDoc: MapDocument;
		
		private var _winNewProject: IPopUpPanel;
		private var _winNewDocument: WindowCreateDocument;
		private var _winCreateDirectory: WindowCreateDirectory;
		
		public function MapEditor()
		{
			_winNewProject = new WindowCreateProject();
			_winNewDocument = new WindowCreateDocument();
			_winCreateDirectory = new WindowCreateDirectory();
		}
		
		public function rebuildFileTree(config: XMLList): void
		{
			EditorImpl.instance.treeProjectFile.dataProvider = config.elements();
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
		
		public function createDocument(doc: IDocument): void
		{
			var current: XML = XML(EditorImpl.instance.treeProjectFile.selectedItem);
			if(current != null && current.@isBranch == "true")
			{
				var id: String = current.@id;
				(doc as MapDocument).parent = FileManagerImpl.instance.getDocument(id);
			}
			
			FileManagerImpl.instance.addDocument(doc as MapDocument);
			ProjectImpl.instance.rebuildXML();
			rebuildFileTree(ProjectImpl.instance.config.file);
		}
		
		public function createEditor(doc: IDocument): void
		{
			_currentSelectedDoc = doc as MapDocument;
			
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
			
			EditorImpl.instance.panelFile.addElement(_fileModule);
		}
		
		private function onEditorModuleReady(evt: ModuleEvent): void
		{
			_editorModule = _editorModuleInfo.factory.create() as IEditor;
			_editorModule.addEventListener(EditorEvent.ITEM_CLICK, onEditorItemClick);
			
			EditorImpl.instance.mainStage.addElement(_editorModule);
			
			if(_currentSelectedDoc != null)
			{
				_editorModule.addDocument(_currentSelectedDoc);
			}
		}
		
		private function onPropertyModuleReady(evt: ModuleEvent): void
		{
			_propertyModule = _propertyModuleInfo.factory.create() as IProperty;
			
			EditorImpl.instance.panelProperty.addElement(_propertyModule);
		}
		
		private function onEditorItemClick(evt: EditorEvent): void
		{
			var doc: MapDocument = evt.document as MapDocument;
			var type: String = evt.targetType;
			
			_propertyModule.showProperty(type, doc);
		}

	}
}