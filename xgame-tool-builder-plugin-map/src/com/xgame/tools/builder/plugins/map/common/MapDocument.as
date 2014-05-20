package com.xgame.tools.builder.plugins.map.common
{
	import com.xgame.tools.builder.plugins.IDocument;
	
	import flash.display.BitmapData;

	public class MapDocument implements IDocument
	{
		private var _id: String;
		private var _name: String;
		private var _path: String;
		private var _map: BitmapData;
		private var _width: Number;
		private var _height: Number;
//		public var tileCountX: int;
//		public var tileCountY: int;
//		public var tileWidth: Number;
//		public var tileHeight: Number;
//		public var blockCountX: int;
//		public var blockCountY: int;
//		public var blockWidth: Number;
//		public var blockHeight: Number;
		private var _isDirectory: Boolean = false;
		private var _config: XML;
		private var _parent: IDocument;
		private var _childDocs: Vector.<IDocument>;
		
		public function MapDocument(id: String, isDirectory: Boolean = false)
		{
			this._id = id;
			this.isDirectory = isDirectory;
			
			if(isDirectory)
			{
				_childDocs = new Vector.<MapDocument>();
			}
		}
		
		public function addDocument(doc: IDocument): void
		{
			if(_childDocs.indexOf(doc) > -1)
			{
				return;
			}
			_childDocs.push(doc);
		}

		public function get childDocs():Vector.<IDocument>
		{
			return _childDocs;
		}

		public function get id():String
		{
			return _id;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}

		public function get map():BitmapData
		{
			return _map;
		}

		public function set map(value:BitmapData):void
		{
			_map = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get isDirectory():Boolean
		{
			return _isDirectory;
		}

		public function set isDirectory(value:Boolean):void
		{
			_isDirectory = value;
		}

		public function get config():XML
		{
			return _config;
		}

		public function set config(value:XML):void
		{
			_config = value;
		}

		public function get parent():IDocument
		{
			return _parent;
		}

		public function set parent(value:IDocument):void
		{
			_parent = value;
		}
	}
}