package com.xgame.tools.mapbuilder.common
{
	import com.xgame.tools.mapbuilder.common.Document;
	import com.xgame.tools.mapbuilder.editor.Editor;
	import com.xgame.tools.mapbuilder.editor.FileManager;
	import com.xgame.tools.mapbuilder.plugins.IProject;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class ProjectImpl
	{
		private static var _instance: ProjectImpl;
		private static var _allowInstance: Boolean = false;
		
		private var impl: IProject;
		
		public function ProjectImpl()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public static function create(type: String): void
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new ProjectImpl();
				_allowInstance = false;
			}
		}
		
		public static function get instance(): ProjectImpl
		{
			return _instance;
		}
		
		public function init(name: String, path: String): void
		{
			impl.init(name, path);
		}
		
		public function save(): void
		{
			impl.save();
		}
		
		public function rebuildXML(): void
		{
			impl.rebuildXML();
		}

		public function get inited():Boolean
		{
			return impl.inited;
		}

		public function get config():XML
		{
			return impl.config;
		}
	}
}