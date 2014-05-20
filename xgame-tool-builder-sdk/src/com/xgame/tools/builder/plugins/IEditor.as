package com.xgame.tools.builder.plugins
{
	import mx.core.IVisualElement;

	public interface IEditor extends IVisualElement
	{
		function addDocument(doc: IDocument): int;
		function switchTab(index: int): void;
	}
}