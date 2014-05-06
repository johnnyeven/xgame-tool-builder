package com.xgame.tools.mapbuilder.common
{
	import com.xgame.tools.mapbuilder.editor.Editor;
	import com.xgame.tools.mapbuilder.editor.FileManager;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Project
	{
		private static var _instance: Project;
		private static var _allowInstance: Boolean = false;
		
		private var _config: XML;
		private var _inited: Boolean = false;
		private var _projectName: String;
		private var _projectPath: String;
		
		public function Project()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public static function get instance(): Project
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Project();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function init(name: String, path: String): void
		{
			if(_inited)
			{
				throw new IllegalOperationError("项目已经初始化");
				return;
			}
			_projectName = name;
			_projectPath = path;
			
			var base: File = new File(_projectPath + "/" + _projectName);
			var _fileStream: FileStream = new FileStream();
			var configFile: File = base.resolvePath("project.builder-config");
			if(configFile.exists)
			{
				_fileStream.open(configFile, FileMode.READ);
				_config = XML(_fileStream.readUTFBytes(_fileStream.bytesAvailable));
				
				FileManager.instance.init();
				Editor.instance.rebuildFileTree(_config.file);
			}
			else
			{
				var dirMap: File = base.resolvePath("map");
				dirMap.createDirectory();
				
				var dirAssets: File = base.resolvePath("assets");
				dirAssets.createDirectory();
				
				FileManager.instance.init();
				rebuildXML();
				Editor.instance.rebuildFileTree(_config.file);
				
				_fileStream.open(configFile, FileMode.WRITE);
				_fileStream.writeUTFBytes(_config);
			}
			_fileStream.close();
			
			_inited = true;
		}
		
		public function save(): void
		{
			rebuildXML();
			
			var file: File = new File(_projectPath + "/" + _projectName);
			var _fileStream: FileStream = new FileStream();
			file = file.resolvePath("project.builder-config");
			
			_fileStream.open(file, FileMode.WRITE);
			_fileStream.writeUTFBytes(_config);
			_fileStream.close();
		}
		
		public function rebuildXML(): void
		{
			_config = <project />;
			
			_config.name = _projectName;
			_config.path = _projectPath;
			_config.file = "";
			
			var fileContainer: Vector.<Document> = FileManager.instance.fileContainer;
			for(var i: int = 0; i<fileContainer.length; i++)
			{
				_config.file.document[i] = rebuildFileList(fileContainer[i]);
			}
		}
		
		private function rebuildFileList(doc: Document): XML
		{
			if(doc != null)
			{
				var config: XML = <document />;
				config.@id = doc.id;
				config.@label = doc.name;
				config.@path = doc.path;
				config.@width = doc.width;
				config.@height = doc.height;
				
				if(doc.isDirectory)
				{
					for(var i: int = 0; i<doc.childDocs.length; i++)
					{
						config.document[i] = rebuildFileList(doc.childDocs[i]);
					}
				}
				
				return config;
			}
			
			return null;
		}

		public function get inited():Boolean
		{
			return _inited;
		}

		public function get config():XML
		{
			return _config;
		}


	}
}