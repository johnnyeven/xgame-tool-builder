package com.xgame.tools.builder.plugins
{
	import mx.core.IVisualElement;
	
	public interface IProperty extends IVisualElement
	{
		function showProperty(type: String, doc: IDocument): void;
	}
}