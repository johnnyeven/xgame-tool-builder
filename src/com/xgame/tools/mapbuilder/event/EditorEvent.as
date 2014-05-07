package com.xgame.tools.mapbuilder.event
{
	import com.xgame.tools.mapbuilder.common.Document;
	
	import flash.events.Event;
	
	public class EditorEvent extends Event
	{
		public static const NAME: String = "EditorEvent";
		public static const ITEM_CLICK: String = NAME + ".ItemClick";
		
		public var document: Document;
		public var targetType: String;
		
		public function EditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}