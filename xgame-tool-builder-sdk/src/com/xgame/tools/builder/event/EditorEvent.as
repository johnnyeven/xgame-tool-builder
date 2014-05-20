package com.xgame.tools.builder.event
{
	import com.xgame.tools.builder.plugins.IDocument;
	
	import flash.events.Event;
	
	public class EditorEvent extends Event
	{
		public static const NAME: String = "EditorEvent";
		public static const ITEM_CLICK: String = NAME + ".ItemClick";
		
		public var document: IDocument;
		public var targetType: String;
		
		public function EditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}