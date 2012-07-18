package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.tools.PolylineVertexLayer;
	import com.esri.ags.tools.PolygonVertexLayer;

	public class MapUtil
	{
		
		/**
		 * Returns an array of all Polyline vertex layers currently in the map.  
		 * Polyline vertex layers are utilised by the edit tool to display and 
		 * edit the vertices of the editable shape. 
		 */ 
		public static function getPolylineVertexLayers(map:Map):Array
		{
			var pLayers:Array = [];
			for each (var layer:Layer in map.layers)
			{
				if (layer is PolylineVertexLayer)
				{
					pLayers.push(layer);
				}
			}
			return pLayers; 
		}
		
		/**
		 * Returns an array of all Polygon vertex layers currently in the map.  
		 * Polygon vertex layers are utilised by the edit tool to display and 
		 * edit the vertices of the editable shape. 
		 */ 
		public static function getPolygonVertexLayers(map:Map):Array
		{
			var pLayers:Array = [];
			for each (var layer:Layer in map.layers)
			{
				if (layer is PolygonVertexLayer)
				{
					pLayers.push(layer);
				}
			}
			return pLayers; 
		}			
	
		/** 
		 * Checks for the existance of a graphics layer with the supplied name.
		 * if a graphics layer with that name is not located, the function 
		 * creates a graphics layer with the supplied name and adds it to the map.
		 */
		public static function checkGraphicLayer(layerID:String, map:Map, layerName:String = ""):GraphicsLayer 
		{
			// Loop through each layer in the map
			for each(var layer:Layer in map.layers) 
			{
				// Only interested if it is a graphics layer
				if(layer is GraphicsLayer) 
				{
					if(layer.id === layerID) 
					{
						// If it already exists then we can leave the function
						return layer as GraphicsLayer;
					}
				}
			}
			
			// If we get this far we need to create the graphics layer and add it to the map
			var graphicsLayer:GraphicsLayer = new GraphicsLayer;
			
			// Set the name/id of the graphics layer 
			graphicsLayer.id = layerID;

			if (layerName == "")
			{
				graphicsLayer.name = graphicsLayer.id;
			}
			else
			{
				graphicsLayer.name = layerName;
			}
			
			// Add the layer to the map
			map.addLayer(graphicsLayer);

			// Return the result 
			return graphicsLayer;
		}			
		
	}
}