package com.xgame.tools.mapbuilder.plugins
{
	import com.xgame.tools.mapbuilder.common.Document;
	
	import mx.core.IVisualElement;
	
	public interface IProperty extends IVisualElement
	{
		function showProperty(type: String, doc: Document): void;
	}
}