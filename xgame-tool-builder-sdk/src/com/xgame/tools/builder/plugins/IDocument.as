package com.xgame.tools.builder.plugins
{
	import flash.display.BitmapData;

	public interface IDocument
	{
		function addDocument(child: IDocument): void;
		function get childDocs():Vector.<IDocument>;
		function get id():String;
		function get name():String;
		function set name(value:String):void;
		function get path():String;
		function set path(value:String):void;
		function get map():BitmapData;
		function set map(value:BitmapData):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get isDirectory():Boolean;
		function set isDirectory(value:Boolean):void;
		function get config():XML;
		function set config(value:XML):void;
		function get parent():IDocument;
		function set parent(value:IDocument):void;
	}
}