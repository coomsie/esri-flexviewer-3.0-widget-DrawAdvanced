package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.utils
{
	import com.esri.ags.symbols.PictureFillSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	
	import spark.utils.TextFlowUtil;
	
	public class SymbolUtil
	{
		/**
		 * Creates a symbol from an object that has been serialised and saved to file or local storage 
		 */
		public static function SerialObjectToSymbol(object:Object):Symbol
		{
			// Create a new symbol
			var symbol:Symbol;
			
			switch(object.symboltype)
			{
				case "SimpleMarkerSymbol":
				{
					symbol = SerialObjectToSimpleMarkerSymbol(object);
					break;
				}
					
				case "SimpleFillSymbol":
				{
					symbol = SerialObjectToSimpleFillSymbol(object);
					break;
				}
					
				case "SimpleLineSymbol":
				{
					symbol = SerialObjectToSimpleLineSymbol(object);
					break;
				}
					
				case "TextSymbol":
				{
					symbol = SerialObjectToTextSymbol(object);					
					break;
				}
			}
			
			return symbol;
		}
		
		/**
		 * Creates a SimpleMarkerSymbol from an object that has been serialised and saved to file or local storage 
		 */
		public static function SerialObjectToSimpleMarkerSymbol(object:Object):SimpleMarkerSymbol
		{
			var symbol:SimpleMarkerSymbol = new SimpleMarkerSymbol();
			
			if (object.alpha)
				symbol.alpha = Number(object.alpha);
			
			if(object.angle)
				symbol.angle = Number(symbol.angle);
			
			if (object.color)
				symbol.color = uint(object.color);
			
			if (object.size)
				symbol.size = Number(object.size);
			
			if (object.style)
				symbol.style = object.style;
			
			if (object.xoffset)
				symbol.xoffset = Number(object.xoffset);
			
			if (object.yoffset)
				symbol.yoffset = Number(object.yoffset);
			
			if (object.outline)
				symbol.outline = SerialObjectToSimpleLineSymbol(object.outline);
			
			return symbol;
		}
		
		/**
		 * Creates a SimpleLineSymbol from an object that has been serialised and saved to file or local storage 
		 */
		public static function SerialObjectToSimpleLineSymbol(object:Object):SimpleLineSymbol
		{
			var symbol:SimpleLineSymbol = new SimpleLineSymbol();
			
			if (object.alpha)
				symbol.alpha = Number(object.alpha);
			
			if (object.color)
				symbol.color = uint(object.color);
			
			if (object.width)
				symbol.width = Number(object.width);
			
			if (object.style)
				symbol.style = object.style;
			
			return symbol;
		}
		
		/**
		 * Creates a SimpleFillSymbol from an object that has been serialised and saved to file or local storage 
		 */
		public static function SerialObjectToSimpleFillSymbol(object:Object):SimpleFillSymbol
		{
			var symbol:SimpleFillSymbol = new SimpleFillSymbol();
			
			if (object.alpha)
				symbol.alpha = Number(object.alpha);
			
			if (object.color)
				symbol.color = uint(object.color);
			
			if (object.outline)
				symbol.outline = SerialObjectToSimpleLineSymbol(object.outline);
			
			if (object.style)
				symbol.style = object.style;
			
			return symbol;
		}

		/**
		 * Creates a TextSymbol from an object that has been serialised and saved to file or local storage 
		 */
		public static function SerialObjectToTextSymbol(object:Object):TextSymbol
		{
			var symbol:TextSymbol = new TextSymbol();
			
			if (object.alpha)
				symbol.alpha = Number(object.alpha);
			
			if (object.angle)
				symbol.angle = Number(object.angle);

			if (object.color)
				symbol.color = uint(object.color);
			
			if (object.background)
				symbol.background = object.background == "true";
			
			if (object.backgroundColor)
				symbol.backgroundColor = uint(object.backgroundColor);
	
			if (object.border)
				symbol.border = object.border == "true";

			if (object.borderColor)
				symbol.borderColor = uint(object.borderColor);

			if (object.htmlText)
				symbol.htmlText = object.htmlText;

			if (object.placement)
				symbol.placement = object.placement;

			if (object.text)
				symbol.text = object.text;

			if (object.xoffset)
				symbol.xoffset = Number(object.xoffset);

			if (object.yoffset)
				symbol.yoffset = Number(object.yoffset);

			if (object.textFormat)
			{
				var textFormat:TextFormat = new TextFormat();

				if (object.textFormat.bold)
					textFormat.bold = object.textFormat.bold == "true";

				if (object.textFormat.italic)
					textFormat.italic = object.textFormat.italic == "true";

				if (object.textFormat.underline)
					textFormat.underline = object.textFormat.underline == "true";

				if (object.textFormat.font)
					textFormat.font = object.textFormat.font;
	
				if (object.textFormat.color)
					textFormat.color = uint(object.textFormat.color);
				
				if (object.textFormat.size)
					textFormat.size = Number(object.textFormat.size);
				
				symbol.textFormat = textFormat;
			}
			
			return symbol;
		}
		
		
		
		/* --------------------------------------------------------------------
		Symbol serialise to object functions
		-------------------------------------------------------------------- */
		
		/**
		 * Serialises a symbol to an object that can be serialised and saved to file or local storage 
		 */
		public static function SymbolToSerialObject(symbol:Symbol):Object
		{
			var object:Object;
			
			// Determine the symboltype and serialise
			if (symbol is SimpleMarkerSymbol)
			{
				object = SimpleMarkerSymbolToSerialObject(symbol as SimpleMarkerSymbol);
			}
			
			if (symbol is SimpleFillSymbol)
			{
				object = SimpleFillSymbolToSerialObject(symbol as SimpleFillSymbol);
			}
			
			if (symbol is SimpleLineSymbol)
			{
				object = SimpleLineSymbolToSerialObject(symbol as SimpleLineSymbol);
			}
			
			if (symbol is TextSymbol)
			{
				object = TextSymbolToSerialObject(symbol as TextSymbol);
			}
			
			return object;
		}
		
		/**
		 * Serialises a SimpleMarkerSymbol to an object that can be serialised and saved to file or local storage 
		 */
		public static function SimpleMarkerSymbolToSerialObject(symbol:SimpleMarkerSymbol):Object
		{
			var object:Object = { symboltype:"SimpleMarkerSymbol" };
			if (symbol)
			{
				if (symbol.alpha)
					object.alpha = symbol.alpha;
				
				if (symbol.angle)
					object.angle = symbol.angle;
				
				if (symbol.color)
					object.color = symbol.color;
				
				if(symbol.size)
					object.size = symbol.size;
				
				if (symbol.style)
					object.style = symbol.style;
				
				if (symbol.xoffset)
					object.xoffset = symbol.xoffset;
				
				if (symbol.yoffset)
					object.yoffset = symbol.yoffset;
				
				if (symbol.outline)
					object.outline = SimpleLineSymbolToSerialObject(symbol.outline);
			}
			return object;
		}
		
		/**
		 * Serialises a SimpleLineSymbol to an object that can be serialised and saved to file or local storage 
		 */
		public static function SimpleLineSymbolToSerialObject(symbol:SimpleLineSymbol):Object
		{
			var object:Object = { symboltype:"SimpleLineSymbol" };
			if (symbol)
			{
				if (symbol.alpha)				
					object.alpha = symbol.alpha;
				
				if (symbol.color)
					object.color = symbol.color;
				
				if (symbol.width)
					object.width = symbol.width;
				
				if (symbol.style)
					object.style = symbol.style;
			}
			return object;
		}
		
		/**
		 * Serialises a SimpleFillSymbol to an object that can be serialised and saved to file or local storage 
		 */
		public static function SimpleFillSymbolToSerialObject(symbol:SimpleFillSymbol):Object
		{
			var object:Object = { symboltype:"SimpleFillSymbol" };
			if (symbol)
			{
				if (symbol.alpha)
					object.alpha = symbol.alpha;
				
				if (symbol.color)
					object.color = symbol.color;
				
				if (symbol.outline)
					object.outline = SimpleLineSymbolToSerialObject(symbol.outline);
				
				if (symbol.style)
					object.style = symbol.style;
			}		
			return object;
		}
		
		/**
		 * Serialises a TextSymbol to an object that can be serialised and saved to file or local storage 
		 */
		public static function TextSymbolToSerialObject(symbol:TextSymbol):Object
		{
			var object:Object = { symboltype:"TextSymbol" };
			if (symbol)
			{
				if (symbol.alpha)
					object.alpha = symbol.alpha;
				
				if (symbol.angle)
					object.angle = symbol.angle;

				if (symbol.background)
					object.background = symbol.background;
					
				if (symbol.backgroundColor)
					object.backgroundColor = symbol.backgroundColor;

				if (symbol.border)
					object.border = symbol.border;
				
				if (symbol.borderColor)
					object.borderColor = symbol.borderColor;
				
				if (symbol.color)
					object.color = symbol.color;

				if (symbol.htmlText)
					object.htmlText = symbol.htmlText;
				
				if (symbol.placement)
					object.placement = symbol.placement;
				
				if (symbol.text)
					object.text = symbol.text;
				
				if (symbol.xoffset)
					object.xoffset = symbol.xoffset;

				if (symbol.yoffset)
					object.yoffset = symbol.yoffset;
				
				if (symbol.textFormat)
				{
					var textFormat:Object = {};
					
					if (symbol.textFormat.align)
						textFormat.align = symbol.textFormat.align;
					
					if (symbol.textFormat.bold)
						textFormat.bold = symbol.textFormat.bold;

					if (symbol.textFormat.italic)
						textFormat.italic = symbol.textFormat.italic;

					if (symbol.textFormat.underline)
						textFormat.underline = symbol.textFormat.underline;

					if (symbol.textFormat.color)
						textFormat.color = symbol.textFormat.color;

					if (symbol.textFormat.font)
						textFormat.font = symbol.textFormat.font;
					
					if (symbol.textFormat.size)
						textFormat.size = symbol.textFormat.size;
					
					object.textFormat = textFormat;
				}
			}		
			return object;
		}
		
		
		
		/* --------------------------------------------------------------------
		Symbol duplicate functions
		-------------------------------------------------------------------- */
		
		/**
		 * Creates a copy of the supplied symbol 
		 */
		public static function DuplicateSymbol(symbol:Symbol):Symbol
		{
			var newSymbol:Symbol;
			
			// Check input type
			if (symbol is SimpleMarkerSymbol)
			{
				newSymbol = DuplicateSimpleMarkerSymbol(symbol as SimpleMarkerSymbol);
			}
			
			if (symbol is SimpleLineSymbol)
			{
				newSymbol = DuplicateSimpleLineSymbol(symbol as SimpleLineSymbol);
			}
			
			if (symbol is SimpleFillSymbol)
			{
				newSymbol = DuplicateSimpleFillSymbol(symbol as SimpleFillSymbol);
			}
			
			if (symbol is TextSymbol)
			{
				newSymbol = DuplicateTextSymbol(symbol as TextSymbol);
			}
			
			return newSymbol;
		}
		
		/**
		 * Creates a copy of the supplied simple marker symbol 
		 */
		public static function DuplicateSimpleMarkerSymbol(symbol:SimpleMarkerSymbol):SimpleMarkerSymbol
		{
			var sms:SimpleMarkerSymbol;
			if (symbol)
			{
				sms = new SimpleMarkerSymbol(symbol.style, symbol.size, symbol.color,symbol.alpha, symbol.xoffset,
					symbol.yoffset,symbol.angle);
				if (symbol.outline)
				{
					var outline:SimpleLineSymbol = DuplicateSimpleLineSymbol(symbol.outline);
					sms.outline = outline;				
				}				
				
			}
			return sms;
		}
		
		/**
		 * Creates a copy of the supplied simple line symbol 
		 */
		public static function DuplicateSimpleLineSymbol(symbol:SimpleLineSymbol):SimpleLineSymbol
		{
			var sls:SimpleLineSymbol;
			if (symbol)
			{
				sls = new SimpleLineSymbol(symbol.style,symbol.color,symbol.alpha,symbol.width);			
			}
			return sls;
		}
		
		/**
		 * Creates a copy of the supplied simple fill symbol 
		 */
		public static function DuplicateSimpleFillSymbol(symbol:SimpleFillSymbol):SimpleFillSymbol
		{
			var sfs:SimpleFillSymbol;
			if (symbol)
			{
				sfs = new SimpleFillSymbol(symbol.style, symbol.color,symbol.alpha);
				if (symbol.outline)
				{
					var outline:SimpleLineSymbol = DuplicateSimpleLineSymbol(symbol.outline);
					sfs.outline = outline;				
				}				
				
			}
			return sfs;
		}
		
		/**
		 * Creates a copy of the supplied text symbol 
		 */
		public static function DuplicateTextSymbol(symbol:TextSymbol):TextSymbol
		{
			var ts:TextSymbol;
			if (symbol)
			{
				ts = new TextSymbol(symbol.text, symbol.htmlText, symbol.color,symbol.alpha, symbol.border, symbol.borderColor, symbol.background,
					symbol.backgroundColor, symbol.placement,symbol.angle, symbol.xoffset, symbol.yoffset);
				ts.alpha = symbol.alpha;
				if (symbol.textFormat)
				{
					var tf:TextFormat = new TextFormat(symbol.textFormat.font,symbol.textFormat.size, symbol.textFormat.color,
						symbol.textFormat.bold,symbol.textFormat.italic,symbol.textFormat.underline);
					ts.textFormat = tf;
				}
			}
			return ts;
		}
		
		
		/* --------------------------------------------------------------------
		Random symbol functions
		-------------------------------------------------------------------- */
		
		/**
		 * Generates a new simple fill symbol with a random colour.
		 * <p>
		 * <b>Parameters:</b><br/>
		 * <ul>
		 * <li><i>style [SimpleFillStyle styletype]: </i> Style type of the symbol to create.  
		 * The default type is <b>solid</b>.  Other possible values include <b>backwarddiagonal, 
		 * cross, diagonalcross, forwarddiagonal, horizontal, null, vertical</b>.</li>
		 * <li><i>showoutline [Boolean]: </i> Determines whether the result symbol should 
		 * include an outline.  <b>true</b> means the symbol will include an outline (solid black) 
		 * while <b>false</b> will hide the outline.</li>
		 * </ul>
		 * </p>
		 */
		public static function RandomSimpleFillSymbol(style:String="solid", showoutline:Boolean = true):SimpleFillSymbol
		{
			// Generate a random colour.
			var colour:uint = Math.random() * 0xFFFFFF;
			
			// Create the base fill symbol.
			var symbol:SimpleFillSymbol = new SimpleFillSymbol(style,colour,0.5);
			
			// Add the outline if necessary
			if (showoutline)
			{
				symbol.outline = new SimpleLineSymbol();
			}
			
			return symbol;
		}
		
		
		/* --------------------------------------------------------------------
		Update symbol functions
		-------------------------------------------------------------------- */
		
		/**
		 * Updates the supplied symbol to match the new Symbol  
		 */
		public static function UpdateSymbol(symbol:Symbol,newSymbol:Symbol):void
		{
			var newSymbol:Symbol;
			
			// Check input type
			if (symbol is SimpleMarkerSymbol)
			{
				UpdateSimpleMarkerSymbol(symbol as SimpleMarkerSymbol, newSymbol as SimpleMarkerSymbol);
			}
			
			if (symbol is SimpleLineSymbol)
			{
				UpdateSimpleLineSymbol(symbol as SimpleLineSymbol, newSymbol as SimpleLineSymbol);
			}
			
			if (symbol is SimpleFillSymbol)
			{
				UpdateSimpleFillSymbol(symbol as SimpleFillSymbol, newSymbol as SimpleFillSymbol);
			}
			
			if (symbol is TextSymbol)
			{
				UpdateTextSymbol(symbol as TextSymbol, newSymbol as TextSymbol);
			}
		}
		
		/**
		 * Updates the supplied simple marker symbol to match the new symbol  
		 */
		public static function UpdateSimpleMarkerSymbol(symbol:SimpleMarkerSymbol,sms:SimpleMarkerSymbol):void
		{
			if (symbol && sms)
			{
				symbol.alpha = sms.alpha;
				symbol.angle = sms.angle;
				symbol.color = sms.color;
				symbol.size = sms.size;
				symbol.style = sms.style;
				symbol.xoffset = sms.xoffset;
				symbol.yoffset = sms.yoffset;
				
				if (sms.outline)
				{
					var outline:SimpleLineSymbol = DuplicateSimpleLineSymbol(sms.outline);
					symbol.outline = outline;				
				}				
				else
				{
					symbol.outline = null;
				}
			}
		}
		
		/**
		 * Updates the supplied simple line symbol to match the new symbol 
		 */
		public static function UpdateSimpleLineSymbol(symbol:SimpleLineSymbol, sls:SimpleLineSymbol):void
		{
			if (symbol && sls)
			{
				symbol.style = sls.style;
				symbol.color = sls.color;
				symbol.alpha = sls.alpha;
				symbol.width = sls.width;			
			}
		}
		
		/**
		 * Updates the supplied simple fill symbol to match the new symbol 
		 */
		public static function UpdateSimpleFillSymbol(symbol:SimpleFillSymbol, sfs:SimpleFillSymbol):void
		{
			if (symbol && sfs)
			{
				symbol.style = sfs.style; 
				symbol.color = sfs.color;
				symbol.alpha = sfs.alpha;
				if (sfs.outline)
				{
					var outline:SimpleLineSymbol = DuplicateSimpleLineSymbol(sfs.outline);
					symbol.outline = outline;				
				}
				else
				{
					symbol.outline = null;
				}
			}
		}
		
		/**
		 * Updates the supplied text symbol to match the new symbol  
		 */
		public static function UpdateTextSymbol(symbol:TextSymbol, ts:TextSymbol):void
		{
			if (symbol && ts)
			{
				symbol.text = ts.text;
				symbol.htmlText = ts.htmlText; 
				symbol.color = ts.color;
				symbol.border = ts.border;
				symbol.borderColor = ts.borderColor;
				symbol.background = ts.background;
				symbol.backgroundColor = ts.backgroundColor;
				symbol.placement = ts.placement;
				symbol.angle = ts.angle; 
				symbol.xoffset = ts.xoffset; 
				symbol.yoffset = ts.yoffset;
				symbol.alpha = ts.alpha; 
				if (ts.textFormat)
				{
					var tf:TextFormat = new TextFormat(ts.textFormat.font,ts.textFormat.size,ts.textFormat.color,
						ts.textFormat.bold,ts.textFormat.italic,ts.textFormat.underline);
					symbol.textFormat = tf;
				}
				else
				{
					symbol.textFormat = null;
				}
			}
		}
	}
}