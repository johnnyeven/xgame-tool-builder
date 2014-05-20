package com.xgame.tools.builder.common
{
	import com.xgame.tools.builder.plugins.IProject;
	
	import flash.errors.IllegalOperationError;

	public class ProjectImpl implements IProject
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