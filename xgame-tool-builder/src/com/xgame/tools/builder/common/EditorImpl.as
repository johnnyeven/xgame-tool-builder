package com.xgame.tools.builder.common
{
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IEditorManager;
	import com.xgame.tools.builder.utils.Reflection;
	
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
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
			
			initPlugin();
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
		
		private function initPlugin(): void
		{
			var pluginDirectory: File = File.applicationDirectory.resolvePath("plugins");
			if(pluginDirectory.isDirectory)
			{
				var pluginList: Array = pluginDirectory.getDirectoryListing();
				var configFile: File;
				var fileStrem: FileStream;
				var config: XML;
				for each(var pluginPath: File in pluginList)
				{
					configFile = pluginPath.resolvePath("config.xml");
					fileStrem = new FileStream();
					fileStrem.open(configFile, FileMode.READ);
					config = XML(fileStrem.readUTFBytes(fileStrem.bytesAvailable));
					loadPluginConfig(pluginPath, config);
					fileStrem.close();
				}
			}
		}
		
		private function loadPluginConfig(path: File, config: XML): void
		{
			if(config.plugin.path != "")
			{
				var file: File = path.resolvePath(config.plugin.path);
				var fileStrem: FileStream = new FileStream();
				var byteArray: ByteArray = new ByteArray();
				var loaderContext: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				loaderContext.allowCodeImport = true;
				fileStrem.open(file, FileMode.READ);
				fileStrem.readBytes(byteArray, 0, fileStrem.bytesAvailable);
				var loader: Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPluginLoadComplete);
				loader.loadBytes(byteArray, loaderContext);
			}
		}
		
		private function onPluginLoadComplete(evt: Event): void
		{
			trace("Ok");
			
			impl = Reflection.createInstance("com.xgame.tools.builder.plugins.map.common.MapEditor", ApplicationDomain.currentDomain);
			impl.showWinNewProject();
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