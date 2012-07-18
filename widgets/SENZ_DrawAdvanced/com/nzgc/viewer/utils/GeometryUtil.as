package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils
{
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.tasks.GeometryService;
	import com.esri.ags.utils.GeometryUtil;
	
	import flash.geom.Point;
	
	import mx.rpc.IResponder;
	
	public class GeometryUtil
	{
		/**
		 * Reconstitutes a serialised geometry.  
		 */
		public static function ObjectToGeometry(object:Object):Geometry
		{
			// Create a geometry reference
			var geometry:Geometry; 
			
			var wkid:Number = Number(object.spatialReference.wkid);
			var spatialref:SpatialReference = new SpatialReference(wkid);		
			var pt:MapPoint;
			
			
			// Check for attributes that are specific to geometry types
			if (object.x && object.y)
			{
				// Geometry is a map point
				pt = new MapPoint(Number(object.x),Number(object.y),spatialref);
				geometry = pt;
			}
			
			if (object.paths)
			{
				// Geometry is a line
				var paths:Array = [];
				
				for each (var pth:Array in object.paths)
				{
					var path:Array = [];
					for each (var mpt:Array in pth)
					{
						pt = new MapPoint(Number(mpt[0]),Number(mpt[1]),spatialref);
						path.push(pt);
					}
					paths.push(path);	
				}
				
				var lin:Polyline = new Polyline(paths,spatialref);
				geometry = lin;
			}
			
			if (object.rings)
			{
				// Geometry is a polygon
				var rings:Array = [];
				
				for each (var rng:Array in object.rings)
				{
					var ring:Array = [];
					for each (var ppt:Array in rng)
					{
						pt = new MapPoint(Number(ppt[0]),Number(ppt[1]),spatialref);
						ring.push(pt);
					}
					rings.push(ring);	
				}
				
				var pol:Polygon = new Polygon(rings,spatialref);
				geometry = pol;
			}
			
			if (object.points)
			{
				// Geometry is a multipoint
				var points:Array = [];
				
				for each (var ept:Object in object.points)
				{
					pt = new MapPoint(Number(ept.x),Number(ept.y),spatialref);
					points.push(pt);
				}
				
				var mul:Multipoint = new Multipoint(points,spatialref);
				geometry = mul;
			}
			
			if (object.width && object.height)
			{
				// Geometry is an extent
				var ext:Extent = new Extent(Number(object.xmin),Number(object.ymin),Number(object.xmax),
					Number(object.ymax),spatialref);
				geometry = ext;
			}
			
			return geometry;
		}
		
		/**
		 * Static method to return a geometry feature moved by a defined x/y offset
		 */
		public static function moveGeometryXYOffset(geometry:Geometry, dx:Number, dy:Number):Geometry
		{
			var newGeometry:Geometry;
			var pt:MapPoint;
			
			// Check the geometry type			
			switch (geometry.type)
			{
				case Geometry.MAPPOINT:
				{
					pt = geometry as MapPoint;
					newGeometry = pt.offset(dx,dy);										
					break;
				}
					
				case Geometry.MULTIPOINT:
				{
					var mulPt:Multipoint = geometry as Multipoint;
					var newMulPt:Multipoint = new Multipoint([],mulPt.spatialReference);
					
					for each (pt in mulPt.points)
					{
						newMulPt.addPoint(pt.offset(dx,dy));	
					}
					newGeometry = newMulPt;
					break;
				}
					
				case Geometry.EXTENT:
				{
					var ext:Extent = geometry as Extent;
					newGeometry = ext.offset(dx,dy);
					break;
				}
					
				case Geometry.POLYGON:
				{
					var pol:Polygon = geometry as Polygon;
					var newPol:Polygon = new Polygon([],pol.spatialReference);
					
					for each (var ring:Array in pol.rings)
					{
						var newRing:Array = [];
						for each (pt in ring)
						{
							newRing.push(pt.offset(dx,dy));
						}
						newPol.rings.push(newRing);
					}
					newGeometry = newPol;
					break;
				}
					
				case Geometry.POLYLINE:
				{
					var lin:Polyline = geometry as Polyline;
					var newLin:Polyline = new Polyline([],lin.spatialReference);
					
					for each (var path:Array in lin.paths)
					{
						var newPath:Array = [];
						for each (pt in path)
						{
							newPath.push(pt.offset(dx,dy));
						}
						newLin.paths.push(newPath);
					}
					newGeometry = newLin;
					break;
				}
			}
			// Return the offset geometry
			return newGeometry;
		}
		
		/**
		 * Static method to return a geometry centered at the given x/y coordinates
		 */
		public static function moveGeometryToXY(geometry:Geometry, x:Number, y:Number):Geometry
		{
			var newGeometry:Geometry;
			var pt:MapPoint;
			
			var dx:Number;
			var dy:Number;
			
			// Check the geometry type			
			switch (geometry.type)
			{
				case Geometry.MAPPOINT:
				{
					pt = geometry as MapPoint;
					dx = x - pt.x;
					dy = y - pt.y;
					
					newGeometry = pt.offset(dx,dy);										
					break;
				}
					
				case Geometry.EXTENT:
				case Geometry.MULTIPOINT:
				case Geometry.POLYGON:
				case Geometry.POLYLINE:
				{
					var ext:Extent = geometry.extent;
					dx = x - ext.center.x;
					dy = y - ext.center.y;
					
					newGeometry = moveGeometryXYOffset(geometry,dx,dy);
					break;
				}
			}
			// Return the offset geometry
			return newGeometry;
		}
		
		/**
		 * Static method to return a geometry centered at the given x/y coordinates
		 */
		public static function createCircle(x:Number, y:Number, radius:Number, sref:SpatialReference, 
											divisions:int = 10, isPoly:Boolean = true):Geometry
		{
			var newGeometry:Geometry;
			var pts:Array = [];
			for (var i:Number = 0; i <= divisions; i++)
			{
				var pointRatio:Number = i/divisions;	
				var xSteps:Number = circleTrigFunctionX(pointRatio);
				var ySteps:Number = circleTrigFunctionY(pointRatio);
				var pointX:Number = x + xSteps * radius;
				var pointY:Number = y + ySteps * radius;
				var pt:MapPoint = new MapPoint(pointX,pointY,sref);
				pts.push(pt);
			}
			
			// Determine if this will be a polyline or a polygon
			if (isPoly)
			{
				var pol:Polygon = new Polygon([pts],sref);
				newGeometry = pol;				
			} 
			else
			{
				var lin:Polyline = new Polyline([pts],sref);
				newGeometry = lin;
			}
			
			// Return the circle geometry
			return newGeometry;
		}
		
		/**
		 * Function used in deterining the x coordinate from a bearing
		 */
		public static function circleTrigFunctionX (pointRatio:Number):Number
		{
			return Math.cos(pointRatio*2*Math.PI);
		}
		
		/**
		 * Function used in deterining the y coordinate from a bearing
		 */
		public static function circleTrigFunctionY (pointRatio:Number):Number
		{
			return Math.sin(pointRatio*2*Math.PI);
		}
		
		/**
		 * Function to return a representative x ccordinate for geometry features.  For line geometry this 
		 * is the x ccordinate of the point at the centre of the line feature, while for polygons this would 
		 * be the x coordinate of the polygon extent.
		 */
		public static function getX(geometry:Geometry):Number
		{
			var x:Number;
			var pt:MapPoint = getMapPoint(geometry);
			
			if (pt)
				x = pt.x;
			
			return x;
		}
		
		/**
		 * Function to return a representative y ccordinate for geometry features.  For line geometry this 
		 * is the y ccordinate of the point at the centre of the line feature, while for polygons this would 
		 * be the y coordinate of the polygon extent.
		 */
		public static function getY(geometry:Geometry):Number
		{
			var y:Number;
			var pt:MapPoint = getMapPoint(geometry);
			
			if (pt)
				y = pt.y;
			
			return y;
		}
		
		/**
		 * Function to return a representative point for geometry features.  For line geometry this 
		 * is the point at the centre of the line feature, while for polygons this would 
		 * be the centroid of the polygon extent.
		 */
		public static function getMapPoint(geometry:Geometry):MapPoint
		{
			var pt:MapPoint;
			
			if (geometry)
			{
				switch (geometry.type)
				{
					case Geometry.MULTIPOINT:
					case Geometry.POLYGON:
					case Geometry.EXTENT:
					{
						pt = geometry.extent.center;	
						break;
					}
						
					case Geometry.POLYLINE:
					{
						const pl:Polyline = geometry as Polyline;
						const pathCount:Number = pl.paths.length;
						const pathIndex:int = int((pathCount / 2) - 1);
						const midPath:Array = pl.paths[pathIndex];
						const ptCount:Number = midPath.length;
						const ptIndex:int = int((ptCount / 2) - 1);
						pt = pl.getPoint(pathIndex, ptIndex);
						break;
					}
						
					case Geometry.MAPPOINT:
					{
						pt = MapPoint(geometry);
						break;
					}
				}
			}
			return pt;
		}
		
		/**
		 * Function to return a representative label point for geometry features.  For line 
		 * geometry this is the point at the centre of the line feature, while for polygons 
		 * this would be the centroid of the polygon extent.
		 */
		public static function getLabelPosition(geom:Geometry):MapPoint
		{
			var pt:MapPoint;
			
			// Determine the type of the geometry being measured. 
			switch (geom.type)
			{
				case Geometry.POLYLINE:
				{
					var polyline:Polyline = geom as Polyline;
					var pathIndex:int;
					if (polyline.paths.length == 1)
					{
						pathIndex = 0;
					}
					else
					{
						pathIndex = int((polyline.paths.length / 2) - 1);
					}
					var path:Array = polyline.paths[pathIndex];
					var ptIndex:int = int(( path.length / 2) - 1);
					pt = polyline.getPoint(pathIndex, ptIndex);
					break;
				}
				case Geometry.POLYGON:
				{
					var polygon:Polygon = geom as Polygon;
					var polygonExtent:Extent;
					if (polygon.rings.length == 1)
					{
						polygonExtent = polygon.extent;
					}
					else
					{
						// Multiple rings, hence show the measurement label at the center of first ring
						var tempPolygon:Polygon = new Polygon;
						tempPolygon.rings = [ polygon.rings[0]];
						polygonExtent = tempPolygon.extent;
					}
					pt = polygonExtent.center;
					break;
				}
				case Geometry.EXTENT:
				{
					pt = geom.extent.center;
					break;
				}
			}
			
			return pt;
		}
		
		/**
		 * Calculates the length of a line segment in map units, and applies conversion factor 
		 */
		public static function getSegmentLength(startPt:MapPoint, endPt:MapPoint, 
												conversion:Number = 1):Number
		{
			var dX:Number = startPt.x - endPt.x;
			var dY:Number = startPt.y - endPt.y;
			
			var lin:Number =  Math.sqrt((dX*dX) + (dY*dY)); 
			return lin * conversion;
		}
		
		/**
		 * Updates the location of a specific vertex in a polyline feature.
		 */
		public static function updatePolylineVertex(polyline:Polyline,oldPt:MapPoint, newPt:MapPoint):Polyline
		{
			// Find the path and point number
			var pathid:int = 0;
			var ptid:int;
			var found:Boolean = false;
			
			// Iterate through each path
			for each (var path:Array in polyline.paths)
			{
				// Reset the point count
				ptid = 0;
				
				// Iterate through the map points
				for each (var pt:MapPoint in path)
				{
					if (pt.x == oldPt.x && pt.y == oldPt.y)
					{
						// Point found - update to the new point location
						polyline.setPoint(pathid,ptid,newPt);
						
						// Update found flag
						found = true;
						break;
					}
					else 
					{
						ptid += 1;
					}
				}
				
				// Increment pathid
				if (found)
				{
					break;
				}
				else 
				{
					pathid += 1;
				}
			}
			
			// Return the updated feature
			return polyline;
		}
		
		/**
		 * Updates the location of a specific vertex in a polygon feature.
		 */
		public static function updatePolygonVertex(polygon:Polygon,oldPt:MapPoint, newPt:MapPoint):Polygon
		{
			// Find the ring and point number
			var ringid:int = 0;
			var ptid:int;
			var found:Boolean = false;
			
			// Iterate through each ring
			for each (var ring:Array in polygon.rings)
			{
				// Reset the point count
				ptid = 0;
				
				// Iterate through the map points
				for each (var pt:MapPoint in ring)
				{
					if (pt.x == oldPt.x && pt.y == oldPt.y)
					{
						// Point found - update to the new point location
						polygon.setPoint(ringid,ptid,newPt);
						
						// Update found flag
						found = true;
						break;
					}
					else 
					{
						ptid += 1;
					}
				}
				
				// Increment pathid
				if (found)
				{
					break;
				}
				else 
				{
					ringid += 1;
				}
			}
			
			// Return the updated feature
			return polygon;
		}
		
		/**
		 * Function to generate an extent around a map point.  For use with search widgets that use points to search layers.  
		 */
		public static function createExtentAroundMapPoint(centerPoint:MapPoint, tolerance:Number, map:Map):Extent
		{
			var screenPoint:Point = map.toScreen(centerPoint as MapPoint);
			
			var upperLeftScreenPoint:Point = new Point(screenPoint.x - tolerance, screenPoint.y - tolerance);
			var lowerRightScreenPoint:Point = new Point(screenPoint.x + tolerance, screenPoint.y + tolerance);
			
			var upperLeftMapPoint:MapPoint = map.toMap(upperLeftScreenPoint);
			var lowerRightMapPoint:MapPoint = map.toMap(lowerRightScreenPoint);
			
			return new Extent(upperLeftMapPoint.x, upperLeftMapPoint.y, lowerRightMapPoint.x, lowerRightMapPoint.y, map.spatialReference);
		}

		/*
		Functions inherited from ESRI GeometryUtil
		*/
		
		/**
		 * Calls the geodesicAreas function of the ESRI GeometryUtil class.
		 */
		public static function geodesicAreas(polygons:Array,areaUnit:String):Array
		{
			return com.esri.ags.utils.GeometryUtil.geodesicAreas(polygons,areaUnit);
		}

		/**
		 * Calls the geodesicDensify function of the ESRI GeometryUtil class.
		 */
		public static function geodesicDensify(geometry:Geometry,maxSegmentLength:Number = 100000):Geometry
		{
			return com.esri.ags.utils.GeometryUtil.geodesicDensify(geometry,maxSegmentLength);
		}

		/**
		 * Calls the geodesicLengths function of the ESRI GeometryUtil class.
		 */
		public static function geodesicLengths(polylines:Array,lengthUnit:String):Array
		{
			return com.esri.ags.utils.GeometryUtil.geodesicLengths(polylines,lengthUnit);
		}

		/**
		 * Calls the normalizeCentralMeridian function of the ESRI GeometryUtil class.
		 */
		public static function normalizeCentralMeridian(geometries:Array,geometryService:GeometryService,responder:IResponder):void
		{
			com.esri.ags.utils.GeometryUtil.normalizeCentralMeridian(geometries,geometryService,responder);
		}
		
		/**
		 * Calls the polygonSelfIntersecting function of the ESRI GeometryUtil class.
		 */
		public static function polygonSelfIntersecting(poly:Polygon):Boolean
		{
			return com.esri.ags.utils.GeometryUtil.polygonSelfIntersecting(poly);
		}
	}
}