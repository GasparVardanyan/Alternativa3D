package core.fs.tara 
{
	import mx.utils.Base64Encoder;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class LOCKER
	{
		private static function char0(index:uint):String
		{
			return Chars.chars[index % 64];
		}
		
		private static function char1(index:uint):String
		{
			return Chars.chars[index % 64 + 64];
		}
		
		//private static function char2(index:uint):String
		//{
			//return Chars.chars[index % 64 + 128];
		//}
		
		public static function fixPassword(password:String):String
		{
			var encoder:Base64Encoder = new Base64Encoder(),  p:String;
			
			if (password)
			{
				encoder.insertNewLines = false;
				encoder.encodeUTFBytes(password);
				p = encoder.toString();
				while (p.length < 64)
				{
					encoder.encodeUTFBytes(p);
					p = encoder.toString();
				}
				p = replacedAll(p, "=", "");
			} else p = "";
			
			return p;
		}
		
		public static function lockBase64(data:String, password:String):String
		{
			var output:String = data;
			var pswrd:SymbolsList = new SymbolsList(fixPassword(password));
			var i:uint, sp:Symbols;
			
			for each (sp in pswrd.list)
				output = replacedAll(output, sp.a, char1(Chars.chars.indexOf(sp.b)));
			
			for (i = 0; i < 64; i++)
				output = replacedAll(output, char1(i), char0(i));
			
			return output;
		}
		
		public static function unlockBase64(data:String, password:String):String
		{
			var output:String = data;
			var pswrd:SymbolsList = new SymbolsList(fixPassword(password));
			var i:uint, sp:Symbols;
			
			for each (sp in pswrd.list)
				output = replacedAll(output, sp.b, char1(Chars.chars.indexOf(sp.a)));
			
			for (i = 0; i < 64; i++)
				output = replacedAll(output, char1(i), char0(i));
			
			return output;
		}
		
		private static function replacedAll(string:String, search:String, replaceTo:String):String
		{
			return string.split(search).join(replaceTo);
		}
	}
}



class Symbols
{
	public var a:String, b:String;
	
	public function Symbols(a:String, b:String)
	{
		this.a = a, this.b = b;
	}
	
	public function toString():String
	{
		return a + " - " + b;
	}
	
	public function clone():Symbols
	{
		return new Symbols(a, b);
	}
}



class SymbolsList
{
	public var list:Vector.<Symbols> = new Vector.<Symbols>();
	
	public function SymbolsList(string:String = "")
	{
		if (string != null) createFrom(getList(string));
	}
	
	public static function getList(string:String):Vector.<Symbols>
	{
		var v:Vector.<Symbols> = new Vector.<Symbols>();
		var s:Array = string.length?string.split(""):[];
		
		for (var i:uint = 0; i < s.length; i++)
			v.push(new Symbols(s[i], s[(i != (s.length - 1)?(i + 1):0)]));
		
		return v;
	}
	
	public function createFrom(symbols:Vector.<Symbols>):void
	{
		list = new Vector.<Symbols>();
		part4(part3(part2(part1(symbols))));
	}
	
	private function part4(tmp:Vector.<Symbols>):void
	{
		var li:Symbols, i:uint, sA:String, sB:String, b:Boolean;
		var fillA:Array = [], fillB:Array = [];
		var fillCount:uint, moveFillA:uint, moveFillB:uint;
		
		for (i = 0; i < 64; i++)
		{
			b = true;
			
			for each (li in list)
			{
				if ((li.a == Chars.chars[i]) || (li.b == Chars.chars[i]))
				{
					b = false;
					break;
				}
			}
			
			if (b) 
			{
				fillA.push(Chars.chars[i]);
				fillB.push(Chars.chars[i]);
			}
		}
		
		fillB.reverse();
		
		fillCount = fillA.length;
		moveFillA = tmp.length % fillCount;
		moveFillB = list.length % fillCount;
		var fillA2:Array = fillA.splice(0, moveFillA), fillA1:Array = fillA;
		var fillB1:Array = fillB.splice(fillCount - moveFillB, moveFillB).reverse(), fillB2:Array = fillB;
		fillA = fillA1.concat(fillA2);
		fillB = fillB1.concat(fillB2);
		
		for (i = 0; i < fillCount; i++)
			list.push(new Symbols(fillA[i], fillB[i]));
	}
	
	private function part3(tmp:Vector.<Symbols>):Vector.<Symbols>
	{
		var fillA:Array = [], fillB:Array = [];
		var sA:String, sB:String;
		var liA:Symbols, liB:Symbols;
		var b:Boolean, i:uint;
		
		for each (liA in list)
		{
			b = true;
			for each (liB in list)
				if (liA.a == liB.b) b = false;
			if (b) fillB.push(liA.a);
		}
		for each (liB in list)
		{
			b = true;
			for each (liA in list)
				if (liA.a == liB.b) b = false;
			if (b) fillA.push(liB.b);
		}
		
		for (i = 0; i < fillA.length; i++)
		{
			list.push(new Symbols(fillA[i], fillB[i]));
		}
		
		return tmp;
	}
	
	private function part2(tmp:Vector.<Symbols>):Vector.<Symbols>
	{
		var fill:Vector.<Symbols> = new Vector.<Symbols>();
		var s:Symbols, li:Symbols;
		var bA:Boolean, bB:Boolean;
		
		for each (s in tmp)
			fill.push(new Symbols(Chars.chars[63 - Chars.chars.indexOf(s.a)], Chars.chars[63 - Chars.chars.indexOf(s.b)]));
		for each (s in fill)
		{
			bA = bB = true;
			for each (li in list)
			{
				if (s.a == li.a)
					bA = false;
				if (s.b == li.b)
					bB = false;
				if (!(bA && bB))
					break;
			}
			if (bA && bB)
			{
				list.push(s.clone());
			}
		}
		
		return tmp;
	}
	
	private function part1(symbols:Vector.<Symbols>):Vector.<Symbols>
	{
		var tmpA:Array = [], tmpB:Array = [];
		var bA:Boolean, bB:Boolean;
		var j:uint;
		var tmp:Vector.<Symbols> = new Vector.<Symbols>();
		
		for (var i:uint = 0; i < symbols.length; i++)
		{
			bA = bB = true;
			
			for (j = 0; j < tmpA.length; j++)
				if (tmpA[j] == symbols[i].a)
				{
					bA = false;
					break;
				}
			for (j = 0; j < tmpB.length; j++)
				if (tmpB[j] == symbols[i].b)
				{
					bB = false;
					break;
				}
			if (bA && bB && symbols[i].a && symbols[i].b)
			{
				tmpA.push(symbols[i].a);
				tmpB.push(symbols[i].b);
				list.push(new Symbols(symbols[i].a, symbols[i].b));
			} else tmp.push(new Symbols(symbols[i].a, symbols[i].b));
		}
		
		return tmp;
	}
}



class Chars
{
	public static const chars:Array = [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",	// 000 - 015	i + 000
		"Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",	// 016 - 031	i + 000
		"g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",	// 032 - 047	i + 000
		"w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/",	// 048 - 063	i + 000
		"А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П",	// 064 - 079	i + 064
		"Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я",	// 080 - 095	i + 064
		"а", "б", "в", "г", "д", "е", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п",	// 096 - 111	i + 064
		"░", "▒", "▓", "│", "┤", "╡", "╢", "╖", "╕", "╣", "║", "╗", "╝", "╜", "╛", "┐",	// 112 - 127	i + 064
	//	"└", "┴", "┬", "├", "─", "┼", "╞", "╟", "╚", "╔", "╩", "╦", "╠", "═", "╬", "╧",	// 128 - 143	i + 128
	//	"╨", "╤", "╥", "╙", "╘", "╒", "╓", "╫", "╪", "┘", "┌", "█", "▄", "▌", "▐", "▀",	// 144 - 159	i + 128
	//	"р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я",	// 160 - 175	i + 128
	//	"Ё", "ё", "Є", "є", "Ї", "ї", "Ў", "ў", "°", "∙", "·", "√", "№", "¤", "■", " "	// 176 - 191	i + 128
	];
}