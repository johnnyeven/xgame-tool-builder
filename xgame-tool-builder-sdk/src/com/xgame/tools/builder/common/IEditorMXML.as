package com.xgame.tools.builder.common
{
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.Tree;

	public interface IEditorMXML
	{
		function get treeProjectFile(): Tree;
		function get panelFile(): Panel;
		function get mainStage(): HBox;
		function get panelProperty(): Panel;
	}
}