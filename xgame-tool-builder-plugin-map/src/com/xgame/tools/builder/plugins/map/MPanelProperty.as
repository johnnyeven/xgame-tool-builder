package com.xgame.tools.builder.plugins.map
{
	import com.xgame.tools.builder.plugins.IDocument;
	import com.xgame.tools.builder.plugins.map.common.MapDocument;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.Group;
	import spark.components.TextInput;
	import spark.layouts.FormLayout;

	public class MPanelProperty
	{
		private static var _instance: MPanelProperty;
		private static var _allowInstance: Boolean = false;
		
		private var _module: MapProperty;
		private var _panelContainer: Dictionary;
		private var _itemContainer: Dictionary;
		
		public function MPanelProperty(m: MapProperty)
		{
			_module = m;
			_panelContainer = new Dictionary();
			_itemContainer = new Dictionary();
		}
		
		public static function init(m: MapProperty): MPanelProperty
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new MPanelProperty(m);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): MPanelProperty
		{
			return _instance;
		}
		
		public function getPanel(type: String): Group
		{
			return _panelContainer[type] as Group;
		}
		
		public function initPanel(): void
		{
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onPropertyLoaded);
			loader.load(new URLRequest("property.xml"));
		}
		
		private function onPropertyLoaded(evt: Event): void
		{
			var info: URLLoader = evt.currentTarget as URLLoader;
			var config: XML = XML(info.data);
			var type: String;
			var form: Group;
			
			for(var i: int = 0; i<config.form.length(); i++)
			{
				type = config.form[i].@type;
				_itemContainer[type] = new Dictionary();
				form = buildForm(type, config.form[i]);
				_panelContainer[type] = form;
			}
		}
		
		private function buildForm(type: String, config: XML): Group
		{
			var group: Group = new Group();
			group.percentWidth = 100;
			var form: Form = new Form();
			form.percentWidth = 100;
			form.styleName = "propertyForm";
			var layout: FormLayout = new FormLayout();
			layout.gap = 0;
			form.layout = layout;
			
			group.addElement(form);
			
			var formItem: FormItem;
			for each(var prop: XML in config.property)
			{
				formItem = new FormItem();
				formItem.label = prop.@label[0];
				formItem.percentWidth = 100;
				
				form.addElement(formItem);
				
				if(prop.@type[0] == "TextInput")
				{
					var itemInput: TextInput = new TextInput();
					itemInput.id = prop.@id;
					itemInput.name = prop.@name;
					itemInput.percentWidth = 100;
					if(prop.@editable[0] == "false")
					{
						itemInput.editable = false;
					}
					
					formItem.addElement(itemInput);
					
					if(_itemContainer[type] != null)
					{
						_itemContainer[type][itemInput.id] = itemInput;
					}
				}
			}
			return group;
		}
		
		public function initFormValue(type: String, doc: IDocument): void
		{
			if(_itemContainer[type] != null)
			{
				for each(var ui: UIComponent in _itemContainer[type])
				{
					try
					{
						if(ui is TextInput)
						{
							if(isNaN(doc[ui.id]))
							{
								doc[ui.id] = 0;
							}
							(ui as TextInput).text = doc[ui.id];
						}
					}
					catch(err: ReferenceError)
					{
						continue;
					}
				}
			}
		}
	}
}