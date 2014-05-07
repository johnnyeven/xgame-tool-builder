package com.xgame.tools.mapbuilder.plugins
{
	import com.xgame.tools.mapbuilder.common.Document;
	
	import mx.core.IVisualElement;

	public interface IEditor extends IVisualElement
	{
		function addDocument(doc: Document): int;
		function switchTab(index: int): void;
	}
}