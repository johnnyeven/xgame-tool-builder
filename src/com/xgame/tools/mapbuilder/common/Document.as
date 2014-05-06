package com.xgame.tools.mapbuilder.common
{
	import flash.display.BitmapData;

	public class Document
	{
		private var _id: String;
		public var name: String;
		public var path: String;
		public var map: BitmapData;
		public var width: Number;
		public var height: Number;
		public var isDirectory: Boolean = false;
		public var config: XML;
		public var parent: Document;
		private var _childDocs: Vector.<Document>;
		
		public function Document(id: String, isDirectory: Boolean = false)
		{
			this._id = id;
			this.isDirectory = isDirectory;
			
			if(isDirectory)
			{
				_childDocs = new Vector.<Document>();
			}
		}
		
		public function addDocument(doc: Document): void
		{
			if(_childDocs.indexOf(doc) > -1)
			{
				return;
			}
			_childDocs.push(doc);
		}

		public function get childDocs():Vector.<Document>
		{
			return _childDocs;
		}

		public function get id():String
		{
			return _id;
		}


	}
}