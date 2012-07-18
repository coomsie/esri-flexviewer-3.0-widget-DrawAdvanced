package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.symbols.FillSymbol;
	import com.esri.ags.symbols.LineSymbol;
	import com.esri.ags.symbols.MarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GraphicTemplate extends EventDispatcher
	{
		public function GraphicTemplate(target:IEventDispatcher=null)
		{
			super(target);
		}

		
		/* --------------
		Public Properties
		-------------- */

		/**
		 * The name of the graphic template.
		 */
		[Bindable]
		public var name:String;

		/**
		 * The description of the graphic template.
		 */
		[Bindable]
		public var description:String;

		/**
		 * The default drawing tool to use when creating graphicss based on this template.
		 */
		[Bindable]
		public var drawingTool:String;

		/**
		 * The base graphic of the graphic template.
		 */
		[Bindable]
		public var prototype:Graphic;
		
		/**
		 * A value by which to group the graphic templates by.
		 */
		[Bindable]
		public var groupname:String;

		/**
		 * Returns the geometry type description of the template 
		 */
		public function get CreateGeometryType():String
		{
			var geometrytype:String = "";
			if (prototype && prototype.symbol)
			{
				if (prototype.symbol is FillSymbol)
				{
					geometrytype = Geometry.POLYGON;
				}

				if (prototype.symbol is LineSymbol)
				{
					geometrytype = Geometry.POLYLINE;
				}
				
				if (prototype.symbol is MarkerSymbol||prototype.symbol is TextSymbol)
				{
					geometrytype = Geometry.MAPPOINT;
				}
				
			}
			return geometrytype;
		}
		
		
		override public function toString():String
		{
			var result:String = "";
			
			result += "name:" + name + "|";
			result += "description:" + description + "|";
			result += "drawingTool:" + drawingTool + "|";
			result += "groupname:" + groupname + "|";
			result += "prototype:" + prototype.toString();
			
			return result;
		}
		
		/* -------------
		Public Constants
		------------- */
		
		/**
		 * The default drawing tool specified for this template is a auto complete polygon tool.
		 */
		public static const TOOL_AUTO_COMPLETE_POLYGON:String = "EditToolAutoCompletePolygon";

		/**
		 * The default drawing tool specified for this template is the circle tool.
		 */
		public static const TOOL_CIRCLE:String = "EditToolCircle";
		
		/**
		 * The default drawing tool specified for this template is the ellipse tool.
		 */
		public static const TOOL_ELLIPSE:String = "EditToolEllipse";
		
		/**
		 * The default drawing tool specified for this template is the freehand tool.
		 */
		public static const TOOL_FREEHAND:String = "EditToolFreehand";

		/**
		 * The default drawing tool specified for this template is the line tool.
		 */
		public static const TOOL_LINE:String = "EditToolLine";

		/**
		 * No default tool is specified.
		 */
		public static const TOOL_NONE:String = "EditToolNone";

		/**
		 * The default drawing tool specified for this template is the point tool.
		 */
		public static const TOOL_POINT:String = "EditToolPoint";

		/**
		 * The default drawing tool specified for this template is the polygon tool.
		 */
		public static const TOOL_POLYGON:String = "EditToolPolygon";
		
		/**
		 * The default drawing tool specified for this template is the rectangle tool.
		 */
		public static const TOOL_RECTANGLE:String = "EditToolRectangle";
	}
}