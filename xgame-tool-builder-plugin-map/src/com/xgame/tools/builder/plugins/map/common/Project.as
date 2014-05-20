package com.xgame.tools.builder.plugins.map.common
{
	import com.xgame.tools.builder.common.EditorImpl;
	import com.xgame.tools.builder.common.FileManagerImpl;
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IProject;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Project implements IProject
	{
		private var _config: XML;
		private var _inited: Boolean = false;
		private var _projectName: String;
		private var _projectPath: String;
		
		public function Project()
		{
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
				
				FileManagerImpl.instance.init();
				EditorImpl.instance.rebuildFileTree(_config.file);
			}
			else
			{
				var dirMap: File = base.resolvePath("map");
				dirMap.createDirectory();
				
				var dirAssets: File = base.resolvePath("assets");
				dirAssets.createDirectory();
				
				FileManagerImpl.instance.init();
				rebuildXML();
				EditorImpl.instance.rebuildFileTree(_config.file);
				
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
			
			var fileContainer: Vector.<IDocument> = FileManagerImpl.instance.fileContainer;
			for(var i: int = 0; i<fileContainer.length; i++)
			{
				_config.file.document[i] = rebuildFileList(fileContainer[i]);
			}
		}
		
		private function rebuildFileList(doc: IDocument): XML
		{
			if(doc != null && doc is MapDocument)
			{
				var d: MapDocument = doc as MapDocument;
				var config: XML = <document />;
				config.@id = d.id;
				config.@label = d.name;
				config.@path = d.path;
				config.@width = d.width;
				config.@height = d.height;
				
				if(d.isDirectory)
				{
					config.@isBranch = "true";
					for(var i: int = 0; i<doc.childDocs.length; i++)
					{
						config.document[i] = rebuildFileList(d.childDocs[i]);
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