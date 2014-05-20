package com.xgame.tools.builder.common
{
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.IFileManager;
	
	import flash.errors.IllegalOperationError;
	
	public class FileManagerImpl implements IFileManager
	{
		private static var _instance: FileManagerImpl;
		private static var _allowInstance: Boolean = false;
		
		private var impl: IFileManager;
		
		public function FileManagerImpl()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public static function get instance(): FileManagerImpl
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new FileManagerImpl();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function init():void
		{
			impl.init();
		}
		
		public function get fileContainer():Vector.<IDocument>
		{
			return impl.fileContainer;
		}
		
		public function addDocument(doc:IDocument):void
		{
			impl.addDocument(doc);
		}
		
		public function getDocument(id:String):IDocument
		{
			return impl.getDocument(id);
		}
	}
}