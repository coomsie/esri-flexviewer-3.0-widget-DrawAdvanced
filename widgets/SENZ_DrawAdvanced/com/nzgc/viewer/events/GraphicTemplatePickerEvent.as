package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events
{
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.GraphicTemplatePicker;
	
	import flash.events.Event;
	
	public class GraphicTemplatePickerEvent extends Event
	{
		public function GraphicTemplatePickerEvent(type:String, graphicTemplatePicker:GraphicTemplatePicker)
		{
			super(type);
			
			_picker = graphicTemplatePicker;
		}
		
		public static const GRAPHIC_TEMPLATE_PICKER_ORGANISEMODECHANGE:String = "organiseModeChange";
		public static const GRAPHIC_TEMPLATE_PICKER_REMOVETEMPLATE:String = "removeTemplate";
		public static const GRAPHIC_TEMPLATE_PICKER_MODIFYTEMPLATE:String = "modifyTemplate";
		public static const GRAPHIC_TEMPLATE_PICKER_TEMPLATESUPDATED:String = "templatesUpdated";
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _picker:GraphicTemplatePicker;
		
		/**
		 * The Graphic Template Picker will be passed via the event. It allows the event dispatcher to publish
		 * data to event listener(s).
		 */
		public function get graphicTemplatePicker():GraphicTemplatePicker
		{
			return _picker;
		}
		
		/**
		 * @private
		 */
		public function set graphicTemplatePicker(value:GraphicTemplatePicker):void
		{
			_picker = value;
		}
		
		
		public override function clone():Event
		{
			return new GraphicTemplatePickerEvent(this.type, this.graphicTemplatePicker);
		}
		
		
	}
}