package com.xgame.tools.builder.plugins.map.common
{
	
	import com.xgame.tools.builder.common.ProjectImpl;
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IFileManager;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class FileManager implements IFileManager
	{
		private var _fileContainer: Vector.<IDocument>;
		private var _fileIndex: Dictionary;
		
		public function FileManager()
		{
		}
		
		public function init(): void
		{
			_fileContainer = new Vector.<MapDocument>();
			_fileIndex = new Dictionary();
			
			if(ProjectImpl.instance.config != null)
			{
				if(ProjectImpl.instance.config.file.document != null)
				{
					var list: XMLList = ProjectImpl.instance.config.file.document;
					for(var i: int = 0; i<list.length(); i++)
					{
						addDocument(parseDocument(ProjectImpl.instance.config.file.document[i]));
					}
				}
			}
		}
		
		private function parseDocument(xml: XML): MapDocument
		{
			var id: String = xml.@id;
			var isDirectory: Boolean = false;
			if(xml.@isBranch == "true")
			{
				isDirectory = true;
			}
			var doc: MapDocument = new MapDocument(id, isDirectory);
			doc.name = xml.@label;
			doc.path = xml.@path;
			doc.width = xml.@width;
			doc.height = xml.@height;
			
			if(xml.@isBranch == "true")
			{
				var child: MapDocument;
				for(var i: int = 0; i<xml.document.length(); i++)
				{
					child = parseDocument(xml.document[i]);
					child.parent = doc;
					addDocument(child);
				}
			}
			
			return doc;
		}

		public function get fileContainer():Vector.<IDocument>
		{
			return _fileContainer;
		}
		
		public function addDocument(doc: IDocument): void
		{
			if(_fileContainer.indexOf(doc) > -1)
			{
				return;
			}
			
			if(doc.parent != null)
			{
				if(doc.parent.childDocs.indexOf(doc) > -1)
				{
					return;
				}
				
				doc.parent.addDocument(doc);
			}
			else
			{
				_fileContainer.push(doc);
			}
			
			_fileIndex[doc.id] = doc;
		}
		
		public function getDocument(id: String): IDocument
		{
			return _fileIndex[id];
		}

	}
}