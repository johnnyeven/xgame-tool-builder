package com.xgame.tools.builder.plugins
{
	public interface IFileManager
	{
		function init(): void;
		function get fileContainer():Vector.<IDocument>;
		function addDocument(doc: IDocument): void;
		function getDocument(id: String): IDocument;
	}
}