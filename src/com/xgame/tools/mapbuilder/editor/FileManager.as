package com.xgame.tools.mapbuilder.editor
{
	import com.xgame.tools.mapbuilder.common.Document;
	import com.xgame.tools.mapbuilder.common.Project;
	
	import flash.errors.IllegalOperationError;

	public class FileManager
	{
		private static var _instance: FileManager;
		private static var _allowInstance: Boolean = false;
		
		private var _fileContainer: Vector.<Document>;
		
		public function FileManager()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public function init(): void
		{
			_fileContainer = new Vector.<Document>();
			
			if(Project.instance.config != null)
			{
				if(Project.instance.config.file.document != null)
				{
					var list: XMLList = Project.instance.config.file.document;
					for(var i: int = 0; i<list.length(); i++)
					{
						_fileContainer.push(parseDocument(Project.instance.config.file.document[i]));
					}
				}
			}
		}
		
		private function parseDocument(xml: XML): Document
		{
			var id: String = xml.@id;
			var isDirectory: Boolean = false;
			if(xml.document != null)
			{
				isDirectory = true;
			}
			var doc: Document = new Document(id, isDirectory);
			doc.name = xml.@label;
			doc.path = xml.@path;
			doc.width = xml.@width;
			doc.height = xml.@height;
			
			if(xml.document != null)
			{
				var child: Document;
				for(var i: int = 0; i<xml.document.length(); i++)
				{
					child = parseDocument(xml.document[i]);
					child.parent = doc;
					doc.childDocs.push(child);
				}
			}
			
			return doc;
		}
		
		public static function get instance(): FileManager
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new FileManager();
				_allowInstance = false;
			}
			return _instance;
		}

		public function get fileContainer():Vector.<Document>
		{
			return _fileContainer;
		}

	}
}