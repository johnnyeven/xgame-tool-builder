package com.xgame.tools.builder.plugins
{
	public interface IEditorManager
	{
		function showWinNewProject(): void;
		function showWinNewDocument(): void;
		function showWinCreateDirectory(): void;
		function createProject(name: String, path: String): void;
		function createDocument(doc: IDocument): void;
		function createEditor(doc: IDocument): void
		function rebuildFileTree(config: XMLList): void;
	}
}