package com.xgame.tools.mapbuilder.common
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;

	public class Editor
	{
		private static var _instance: Editor;
		private static var _allowInstance: Boolean = false;
		
		private var _winNewProject: TitleWindow;
		
		public function Editor()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
			
			_winNewProject = new TitleWindow();
			_winNewProject.title = "新建项目";
			_winNewProject.width = 500;
			_winNewProject.height = 250;
			_winNewProject.addEventListener(CloseEvent.CLOSE, onWinNewProjectClose);
		}
		
		public static function get instance(): Editor
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Editor();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function showWinNewProject(container: DisplayObject): void
		{
			PopUpManager.addPopUp(_winNewProject, container, true);
			PopUpManager.centerPopUp(_winNewProject);
		}
		
		private function onWinNewProjectClose(evt: CloseEvent): void
		{
			PopUpManager.removePopUp(_winNewProject)
		}
	}
}