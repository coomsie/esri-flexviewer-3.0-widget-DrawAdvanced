package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.*;
	import com.esri.ags.layers.GraphicsLayer;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses.GraphicPropertiesItem;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils.GeometryUtil;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils.SymbolUtil;
	
	import mx.utils.ObjectUtil;

	public class GraphicUtil
	{
		/**
		 * Reconstitutes a serialised graphic. 
		 */
		public static function SerialObjectToGraphic(object:Object):Graphic
		{
			// Create a new graphic
			var graphic:Graphic = new Graphic();
			
			// Check that an object was passed through
			if (object)
			{
				// Check the object for a geometry object
				if (object.geometry)
				{
					graphic.geometry = GeometryUtil.ObjectToGeometry(object.geometry);
				}
				
				// Check the object for a symbol object
				if (object.symbol)
				{
					graphic.symbol = SymbolUtil.SerialObjectToSymbol(object.symbol);
				}
				
				// Check the object for an attributes object
				if (object.attributes)
				{
					// Check to see if attributes came from a GraphicPropertiesItem
					if (object.attributes && object.attributes.objectType == "GraphicPropertiesItem")
					{
						var props:GraphicPropertiesItem = new GraphicPropertiesItem(graphic);
						props.areaMeasurement = object.attributes.areaMeasurement;
						props.lengthMeasurement = object.attributes.lengthMeasurement;
						props.content = object.attributes.content;
						props.showMeasurements = object.attributes.showMeasurements;
						props.title = object.attributes.title;
						props.link = object.attributes.link;
						props.attributes = object.attributes.attributes;
						graphic.attributes = props;
					}
					else
					{
						graphic.attributes = object.attributes;
					}
				}
			}
			return graphic;
		}
		
		/**
		 * Serialises a graphic to an object that can be saved. 
		 */
		public static function GraphicToSerialObject(graphic:Graphic):Object
		{
			var object:Object = {};

			object.geometry = graphic.geometry;
			
			if (graphic.attributes is GraphicPropertiesItem)
			{
				object.attributes = GraphicPropertiesItem(graphic.attributes).toObject();
			}
			else
			{
				object.attributes = graphic.attributes;
			}
			object.symbol = SymbolUtil.SymbolToSerialObject(graphic.symbol);
			
			return object;			
		}
		
		/**
		 * Makes an exact copy of an existing graphic
		 */ 
		public static function CopyGraphic(copyGraphic:Graphic):Graphic
		{
			// Copy the graphic
			var graphic:Graphic = new Graphic();
			graphic.geometry = copyGraphic.geometry;
			graphic.symbol = SymbolUtil.DuplicateSymbol(copyGraphic.symbol);
			
			if (copyGraphic.attributes is GraphicPropertiesItem)
			{
				var props:GraphicPropertiesItem = new GraphicPropertiesItem(graphic);
				var copyProps:GraphicPropertiesItem = GraphicPropertiesItem(copyGraphic.attributes);
				props.attributes = copyProps.attributes;
				props.showMeasurements = copyProps.showMeasurements;
				props.title = copyProps.title;
				props.content = copyProps.content;
				props.point = copyProps.point;
				props.link = copyProps.link;
				props.areaMeasurement = copyProps.areaMeasurement;
				props.lengthMeasurement = copyProps.lengthMeasurement;
				graphic.attributes = props;
			}
			else
			{
				graphic.attributes = copyGraphic.attributes;
			}
			
			return graphic;			
		}	
	}
}