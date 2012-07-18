package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events
{
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses.GraphicTemplate;
	
	import flash.events.Event;
	
	public class GraphicTemplateEvent extends Event
	{
		public function GraphicTemplateEvent(type:String, selectedTemplate:GraphicTemplate = null)
		{
			super(type);
			
			_template = selectedTemplate;
		}
		
		public static const SELECTED_TEMPLATE_CHANGE:String = "selectedTemplateChange";
			
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _template:GraphicTemplate;
		
		/**
		 * The template will be passed via the event. It allows the event dispatcher to publish
		 * data to event listener(s).
		 */
		public function get selectedTemplate():GraphicTemplate
		{
			return _template;
		}
		
		/**
		 * @private
		 */
		public function set selectedTemplate(value:GraphicTemplate):void
		{
			_template = value;
		}
		
		
		public override function clone():Event
		{
			return new GraphicTemplateEvent(this.type, this.selectedTemplate);
		}
		
	}
}