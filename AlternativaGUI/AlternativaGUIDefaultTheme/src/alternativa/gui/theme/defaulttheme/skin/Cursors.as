package alternativa.gui.theme.defaulttheme.skin {
	import alternativa.gui.mouse.CursorData;
	import alternativa.gui.mouse.CursorDelay;
	import alternativa.gui.mouse.CursorManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.MouseCursorData;
	
	
	public class Cursors {
		
		// RU: Курсор: Переместить
        // EN: Cursor: Move
		[Embed(source="../resources/cursors/move.png")] 
		private static const moveCursorTexture:Class;
		protected static const moveCursor:BitmapData = new moveCursorTexture().bitmapData;
		
		// RU: Курсор: Изменение горизонтальных размеров
        // EN: Cursor: Change of horizontal postion
		[Embed(source="../resources/cursors/ew.png")]
		private static const ewCursorTexture:Class;
		protected static const ewCursor:BitmapData = new ewCursorTexture().bitmapData;
		
		// RU: Курсор:  Выделение текста
        // EN: Cursor:  Text selection
		[Embed(source="../resources/cursors/beam.png")] 
		private static const beamCursorTexture:Class;
		protected static const beamCursor:BitmapData = new beamCursorTexture().bitmapData;
		
		// RU: Курсор: "Лапка"
        // EN: Cursor: "Hand"
		[Embed(source="../resources/cursors/link.png")] 
		private static const linkCursorTexture:Class;
		protected static const linkCursor:BitmapData = new linkCursorTexture().bitmapData;
		
		// RU: Курсор: Основной
        // EN: Cursor: Main cursor
		[Embed(source="../resources/cursors/arrow.png")] 
		private static const arrowCursorTexture:Class;
		protected static const arrowCursor:BitmapData = new arrowCursorTexture().bitmapData;
		
		// RU: Курсор: Изменение вертикальных размеров
        // EN: Cursor: Change of vertical postion
		[Embed(source="../resources/cursors/ns.png")] 
		private static const nsCursorTexture:Class;
		protected static const nsCursor:BitmapData = new nsCursorTexture().bitmapData;
		
		// RU: Курсор: Изменение размеров по диагонали 1
        // EN: Cursor: Resize on diagonal 1
		[Embed(source="../resources/cursors/nwse.png")] 
		private static const nwseCursorTexture:Class;
		protected static const nwseCursor:BitmapData = new nwseCursorTexture().bitmapData;
		
		// RU: Курсор: Изменение размеров по диагонали 2
        // EN: Cursor: Resize on diagonal 2
		[Embed(source="../resources/cursors/nesw.png")] 
		private static const neswCursorTexture:Class;
		protected static const neswCursor:BitmapData = new neswCursorTexture().bitmapData;
		
		
		// RU: Создание кастомных курсоров
		// EN: Create custom cursors
		public static function createCursors():Vector.<CursorData> {
			var vector:Vector.<CursorData> = new Vector.<CursorData>();
			
			var moveCursorData:MouseCursorData = new MouseCursorData();
			var moveCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			moveCursorBD.push(moveCursor);
			moveCursorData.data = moveCursorBD;
			moveCursorData.hotSpot = new Point(10,10);
			vector.push(new CursorData(CursorManager.CROSS, moveCursorData));
			
			var ewCursorData:MouseCursorData = new MouseCursorData();
			var ewCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			ewCursorBD.push(ewCursor);
			ewCursorData.data = ewCursorBD;
			ewCursorData.hotSpot = new Point(10,10);
			vector.push(new CursorData(CursorManager.SIZE_WE, ewCursorData));
			
			var beamCursorData:MouseCursorData = new MouseCursorData();
			var beamCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			beamCursorBD.push(beamCursor);
			beamCursorData.data = beamCursorBD;
			beamCursorData.hotSpot = new Point(10,10);
			vector.push(new CursorData(CursorManager.IBEAM, beamCursorData));
			
			var linkCursorData:MouseCursorData = new MouseCursorData();
			var linkCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			linkCursorBD.push(linkCursor);
			linkCursorData.data = linkCursorBD;
			linkCursorData.hotSpot = new Point(8,1);
			vector.push(new CursorData(CursorManager.BUTTON, linkCursorData));
			
			var handCursorData:MouseCursorData = new MouseCursorData();
			var handCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			handCursorBD.push(linkCursor);
			handCursorData.data = handCursorBD;
			handCursorData.hotSpot = new Point(8,1);
			vector.push(new CursorData(CursorManager.HAND, handCursorData));
			
			var arrowCursorData:MouseCursorData = new MouseCursorData();
			var arrowCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			arrowCursorBD.push(arrowCursor);
			arrowCursorData.data = arrowCursorBD;
			arrowCursorData.hotSpot = new Point(4,1);
			vector.push(new CursorData(CursorManager.ARROW, arrowCursorData));
			
			var nsCursorData:MouseCursorData = new MouseCursorData();
			var nsCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			nsCursorBD.push(nsCursor);
			nsCursorData.data = nsCursorBD;
			nsCursorData.hotSpot = new Point(10,9);
			vector.push(new CursorData(CursorManager.SIZE_NS, nsCursorData));
			
			var nwseCursorData:MouseCursorData = new MouseCursorData();
			var nwseCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			nwseCursorBD.push(nwseCursor);
			nwseCursorData.data = nwseCursorBD;
			nwseCursorData.hotSpot = new Point(11,10);
			vector.push(new CursorData(CursorManager.SIZE_NWSE, nwseCursorData));
			
			var neswCursorData:MouseCursorData = new MouseCursorData();
			var neswCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			neswCursorBD.push(neswCursor);
			neswCursorData.data = neswCursorBD;
			neswCursorData.hotSpot = new Point(10,10);
			vector.push(new CursorData(CursorManager.SIZE_NESW, neswCursorData));
			
			return vector;
		}
	}
}