package com.xgame.tools.builder.plugins
{
	public interface IProject
	{
		function init(name: String, path: String): void;
		function save(): void;
		function rebuildXML(): void;
		function get inited():Boolean;
		function get config():XML;
	}
}