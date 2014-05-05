package com.xgame.tools.mapbuilder.common
{
	import flash.errors.IllegalOperationError;

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
			
			_config = new XML();
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
			
			_config.name = name;
			_config.path = path;
			trace(_config);
		}
	}
}