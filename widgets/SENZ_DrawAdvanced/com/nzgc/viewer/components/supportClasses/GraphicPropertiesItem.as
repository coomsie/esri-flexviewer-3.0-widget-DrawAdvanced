package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Bindable]
	public class GraphicPropertiesItem extends EventDispatcher
	{
		public function GraphicPropertiesItem(sourcegraphic:Graphic, target:IEventDispatcher=null)
		{
			super(target);
			
			if (sourcegraphic)
			{
				attributes = sourcegraphic.attributes;
				graphic = sourcegraphic;
				symbol = sourcegraphic.symbol;
				
				// Set the title and content from the attributes 
				if (attributes && attributes["title"])
				{
					// Attributes contain title and description information - use as title on graphic
					title = attributes["title"];
				}
				else
				{
					// No attribute information - use default settings for title and content
					if (sourcegraphic.geometry)
					{
						switch (sourcegraphic.geometry.type)
						{
							case Geometry.MAPPOINT:
							{
								// Check symbol type
								if (sourcegraphic.symbol is TextSymbol)
								{
									title = "Label Graphic";						
								}
								else
								{
									title = "Marker Graphic";						
								}
								break;
							}
								
								case Geometry.MULTIPOINT:
							{
								title = "Multipoint Graphic";							
								break;
							}
								
								case Geometry.POLYLINE:
							{
								title = "Line Graphic";						
								break;
							}
								
								case Geometry.EXTENT:
							case Geometry.POLYGON:
							{
								title = "Polygon Graphic";							
								break;
							}
						}
					}
				}
			}
		}

		/**
		 * Flag used by GraphicPropertiesItemRenderer as an identifier for the type of render action to use.
		 */
		public function get objectType():String 
		{
			return "GraphicPropertiesItem";
		}
		
		/**
		 * Attribute details for the graphic.  Used to store the original attributes of the graphic if created outside 
		 */
		public var attributes:Object;

		/**
		 * Selection state flag for the graphic. 
		 */
		public var selected:Boolean = false;
		
		/**
		 * String used as the title on popups and in the summary view.  Usually the value of the primary display field.  
		 */
		public var title:String = "";
		
		/**
		 * Symbol used to render the graphic on the display
		 */
		public var symbol:Symbol;
		
		/**
		 * String containing the values to be displayed
		 */
		public var content:String = "";
		
		/**
		 * Map point used as the anchor of the popup 
		 */
		public var point:MapPoint;
		
		/**
		 * Shape of the returned feature
		 */
		public var geometry:Geometry;	
		
		/**
		 * Link string for infowindow popups 
		 */
		public var link:String = "";
		
		/**
		 * Graphic used to display this result on the map 
		 */
		public var graphic:Graphic;

		/**
		 * Flag for whether a measure label should be associated with this graphic 
		 */
		public var showMeasurements:Boolean;

		/**
		 * Calculated area of the geometry.  Only appropriate for polygon geometry types.
		 */
		public var areaMeasurement:Number = 0;
		
		/**
		 * Calculated length or perimeter of the geometry.  Only appropriate for polyline and polygon geometry types
		 */
		public var lengthMeasurement:Number;
		
		/**
		 * Serialises this component to a generic object. 
		 */
		public function toObject():Object
		{
			var object:Object = {
				objectType:"GraphicPropertiesItem",
				title:title,
				content:content,
				link:link,
				showMeasurements:showMeasurements,
				areaMeasurement:areaMeasurement,
				lengthMeasurement:lengthMeasurement,
				attributes:attributes
				};
			
			return object;
		}
	}
}