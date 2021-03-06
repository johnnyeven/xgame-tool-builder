package com.xgame.tools.builder.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class Reflection extends Object
	{
		public function Reflection()
		{
			super();
		}
		
		public static function createInstance(name: String, domain: ApplicationDomain = null): *
		{
			var _class: Class = getClass(name, domain);
			if(_class != null)
			{
				var _do: * = new _class();
				return _do;
			}
			return null;
		}
		
		public static function getClass(name: String, domain: ApplicationDomain = null): Class
		{
			if(domain == null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			try
			{
				var _class: Class = domain.getDefinition(name) as Class;
				return _class;
			}
			catch(err: Error)
			{
			}
			return null;
		}
	}
}