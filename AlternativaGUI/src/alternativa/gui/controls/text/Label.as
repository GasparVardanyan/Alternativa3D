package alternativa.gui.controls.text {
import alternativa.gui.base.GUIobject;
import alternativa.gui.enum.Align;
import alternativa.gui.mouse.CursorManager;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.engine.BreakOpportunity;
import flash.text.engine.ContentElement;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontWeight;
import flash.text.engine.GraphicElement;
import flash.text.engine.GroupElement;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;
import flash.text.engine.TextLineMirrorRegion;
import flash.ui.Mouse;
import flash.ui.MouseCursor;


/**
 * Текстовое поле на основе FTE.
 * <p>Не поддерживает ввод текста. LabelTF, TextInput и TextArea поддерживают ввод текста.</p>
 *
 * @see LabelTF
 * @see TextArea
 * @see TextInput
 *
 */
public class Label extends GUIobject {
    public static var fontDescription:FontDescription;

    protected var ef:ElementFormat = new ElementFormat(fontDescription);

    protected var line:TextLine;

    protected var _text:String;

    protected var _size:int;

    protected var _autosize:Boolean = true;

    protected var _height:int = 0;

    protected var _lineHeight:Number = 0;

    protected var _width:Number = 0;

    private var _numLines:int = 0;

    protected var _indent:int = 0;

    protected var _color:int = 0;

    protected var _bold:Boolean = false;

    protected var _anyBreak:Boolean = false;

    protected var _align:Align;

    protected var _leading:Number = 0;

    protected var _maxTextWidth:Number = 0;

    protected var _maxLinesNum:int = 0;

    protected var elements:Vector.<ContentElement>;

    protected var lines:Vector.<TextLine>;

    protected var additionalContent:Array;

    protected var myEvent:EventDispatcher = new EventDispatcher();

    protected var active:Boolean = false;

    /**
     *
     * @param autosize Если true - ширина принимает значение по контенту. Если false - ширина задается извне, высота принимает значение по контенту.
     *
     */
    public function Label(autosize:Boolean = true) {
        super();
        additionalContent = new Array();
        lines = new Vector.<TextLine>();
		elements = new Vector.<ContentElement>();

        mouseChildren = false;
        _autosize = autosize;
        //        size = 13;
        _align = Align.LEFT;
        anyBreak = false;

        myEvent.addEventListener(MouseEvent.CLICK, myEvent_clickHandler);
        myEvent.addEventListener("mouseOut", mouseOutHandler);
        myEvent.addEventListener("mouseOver", mouseOverHandler);
    }

    /**
     * Перерисовка контента.
     *
     */
    public function update():void {
//		trace("Label update");
        while (numChildren > 0) {
            removeChildAt(0);
            lines.pop();
        }
        if ((_autosize || _width > 0) && updateContent()) {
            var tb:TextBlock = new TextBlock(new GroupElement(elements, ef));
            var pl:TextLine;
            var tl:TextLine;
            var _maxWidth:int = 0;
            var currentLine:int = 0;
            var firstLineAscent:int;
            var firstLineHeight:int;

            _height = 0;
            _numLines = 0;


            tl = tb.createTextLine(pl, _autosize ? TextLine.MAX_LINE_WIDTH : _width - _indent, 0, true);

            //эксперимент
            firstLineAscent = tl.ascent;
            firstLineHeight = tl.height + (tl.height * _leading);

            if (tl != null) {
                tl.x = _indent;
                _lineHeight = tl.ascent;
                if (_autosize) {
                    _width = tl.width;
                } else {
                    _maxWidth = _width;
                }
            }

            while (tl != null) {
//                _height += pl ? tl.height + (tl.height * _leading) : ( tl.ascent == 0 ? tl.height : tl.ascent);
                _height += pl ? firstLineHeight : (firstLineAscent == 0 ? firstLineHeight : firstLineAscent);
                tl.y = _height;
                tl.mouseEnabled = active;
                tl.mouseChildren = active;
                addChild(tl);
                lines.push(tl);

                //            if (_maxWidth < _width) _maxWidth = _width;
                if (_maxWidth < tl.width)
                    _maxWidth = tl.width;

                currentLine++;
                if (_maxLinesNum > 0 && currentLine == _maxLinesNum && tb.createTextLine(tl, _width) != null) {
                    cutLine(tl, pl, tb, ef);
                    break;
                }

                pl = tl;
                tl = tb.createTextLine(pl, _autosize ? TextLine.MAX_LINE_WIDTH : _width, 0, true);
            }
            _numLines = currentLine;
            if (_autosize) {
                _width = maxTextWidth;
            }

            var i:int;
            var line:TextLine;
            if (_align != Align.LEFT) {
                for (i = 0; i < numChildren; i++) {
                    line = (getChildAt(i)) as TextLine;
                    line.x = (_align == Align.CENTER) ? (_maxWidth - line.width) >> 1 : (_maxWidth - line.width);
                }
            }
        }
    }

    /**
     * Добавляет текстовый блок в контент.
     * @param text Текст.
     *
     */
    public function addText(text:String):void {
        if (text != null) {
            additionalContent.push(text);
        }
    }

    /**
     * Ссылка на текстовую строку по индексу.
     * @param index Индекс.
     * @return Экземпляр TextLine.
     *
     */
    public function getLine(index:int):TextLine {
        return (lines.length < index) ? lines[index] : null;
    }

    /**
     * Количество строк в текстовом блоке.
     *
     */
    public function get numLines():int {
        return _numLines;
    }

    /**
     * Добавить графический элемент в контент.
     *
     */
    public function addGraphic(obj:DisplayObject):void {
        if (obj != null) {
            additionalContent.push(obj);
        }
    }

    /**
     * Перестроение контента.
     * @return true - если количество элементов больше 0. false - нет элементов для отображения.
     *
     */
    protected function updateContent():Boolean {

        var graphicElementFormat:ElementFormat = new ElementFormat();

        //        graphicElementFormat.alignmentBaseline = TextBaseline.IDEOGRAPHIC_CENTER;

        //        trace(content);

        //elements = new Vector.<ContentElement>();
		elements.length = 0;

        for each (var obj:Object in additionalContent) {
            if (obj is DisplayObject) {
                var label:DisplayObject = obj as DisplayObject;
                elements.push(new GraphicElement(label, label.width, label.height, graphicElementFormat));
            } else {
                pushTextString(obj as String);
                //                elements.push(new TextElement(obj as String, ef));
            }

        }

        if (_text != null && _text.length > 0)
            pushTextString(_text);


        //elements.push(new TextElement(_text, ef));

        return (elements.length > 0);
    }

    private function pushTextString(str:String):void {
        //      "b","/b","size=\d+","/size","color=0x[0-9A-Fa-f]{6}","/color","url=\w+", "/url"
        var tags:RegExp = /(\|b\||\|\/b\||\|size=\d+\||\|\/size\||\|color=0x[0-9A-Fa-f]{6}\||\|\/color\||\|url=[a-z0-9@\+\.:\&\$\#\?\/]+\||\|\/url\|)/g;
        var content:Array = str.split(tags);
        var currentString:String;
        var fdClone:FontDescription;
        var oldSize:int = 0;
        var oldColor:uint = 0;
        var savingURL:String = '';

        for each (currentString in content) {
            if (currentString != null) {
                if (currentString == "|b|") {
                    fdClone = fontDescription.clone();
                    fdClone.fontWeight = FontWeight.BOLD;
                    ef = ef.clone();
                    ef.fontDescription = fdClone;
                } else

                if (currentString == "|/b|") {
                    fdClone = fontDescription.clone();
                    fdClone.fontWeight = FontWeight.NORMAL;
                    ef = ef.clone();
                    ef.fontDescription = fdClone;
                } else

                if (currentString.match(/(\|size=\d+\|)/)) {
                    oldSize = ef.fontSize;
                    ef = ef.clone();
                    ef.fontSize = int(currentString.match(/\d+/)[0]);
                } else

                if (currentString == "|/size|") {
                    ef = ef.clone();
                    ef.fontSize = oldSize;
                } else

                if (currentString.match(/(\|color=(#|0x)?[0-9A-Fa-f]{6}\|)/)) {
                    oldColor = ef.color;
                    ef = ef.clone();
                    ef.color = uint("0x" + currentString.match(/[0-9A-Fa-f]{6}/)[0]);
                } else

                if (currentString == "|/color|") {
                    ef = ef.clone();
                    ef.color = oldColor;
                } else

                if (currentString.match(/(\|url=[a-z0-9@\+\.:\&\$\#\?\/]+\|)/)) {
                    savingURL = currentString.substr(5, currentString.length - 6);
                } else

                if (currentString == "|/url|") {
                    savingURL = '';
                } else {
                    var element:TextElement = new TextElement(currentString, ef);
                    if (savingURL != '') {
                        element.userData = savingURL;
                        element.eventMirror = myEvent;
                        trace("add url", savingURL, "to", element);
                        active = true;
                        mouseChildren = true;
                        mouseEnabled = true;
                    }
                    elements.push(element);
                }

            }
        }
    }


    private function cutLine(tl:TextLine, pl:TextLine, tb:TextBlock, ef:ElementFormat):void {
        var _y:Number = tl.y;
        var nte:TextElement = new TextElement("…", ef);
        var threeDots:TextLine = new TextBlock(nte).createTextLine();
        removeChild(tl);
        tl = tb.createTextLine(pl, _width - threeDots.width);
        tl.y = _y;
        addChild(tl);
        threeDots.x = tl.width;
        tl.addChild(threeDots);
    }

    /**
     * Возвращает основной текст контента без дополнительных текстовых и графических блоков..
     * @return Текст.
     *
     */
    public function get text():String {
        return _text;
    }

    public function set text(value:String):void {
        if (_text != value) {
            _text = value;
            update();
        }
    }

    /**
     * Максимальная ширина текстовой строки.
     *
     */
    public function get maxTextWidth():Number {
        _maxTextWidth = 0;
        var line:TextLine;
        for (var i:int = 0; i < numChildren; i++) {
            line = getChildAt(i) as TextLine;
            if (_maxTextWidth < line.width) {
                _maxTextWidth = line.width;
            }
        }
        return _maxTextWidth;
    }

    /**
     *  Параметр autosize.
     *
     */
    public function get autosize():Boolean {
        return _autosize;
    }

    public function set autosize(value:Boolean):void {
        _autosize = value;
        update();
    }

    /**
     * Размер шрифта.
     *
     */
    public function get size():int {
        return _size;
    }

    public function set size(value:int):void {
        if (_size != value) {
            _size = value;
            ef = ef.clone();
            ef.fontSize = _size;
            update();
        }
    }

    /**
     * Цвет шрифта.
     *
     */
    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        if (_color != value) {
            _color = value;
            ef = ef.clone();
            ef.color = _color;
            update();
        }
    }

    /**
     * Полужирный текст.
     *
     */
    public function get bold():Boolean {
        return _bold;
    }

    public function set bold(value:Boolean):void {
        if (_bold != value) {
            _bold = value;
            var fdClone:FontDescription = fontDescription.clone();
            fdClone.fontWeight = _bold ? FontWeight.BOLD : FontWeight.NORMAL;
            ef = ef.clone();
            ef.fontDescription = fdClone;
            update();
        }
    }

    /**
     * Отступ абзаца, красная строка.
     *
     */
    public function get indent():int {
        return _indent;
    }

    public function set indent(value:int):void {
        if (_indent != value) {
            _indent = value;
            update();
        }
    }

    /**
     * Межстрочный интервал.
     *
     */
    public function get leading():Number {
        return _leading;
    }

    public function set leading(value:Number):void {
        if (_leading != value) {
            _leading = value;
            update();
        }
    }

    override public function set width(value:Number):void {
//		trace("resize")
//		trace("     old Width: " + _width);
//		trace("     new Width: " + int(value));
        if (_width != int(value)) {
            _width = int(value);
            update();
        }
    }

    override public function get width():Number {
        return _width;
    }


    override public function get height():Number {
        return _height;
    }

    override public function set height(value:Number):void {

    }

    /**
     * Высота одной строки.
     *
     */
    public function get lineHeight():Number {
        return _lineHeight;
    }

    /**
     * Выравнивание по горизонтали.
     *
     */
    public function get align():Align {
        return _align;
    }

    public function set align(value:Align):void {
        if (_align != value) {
            _align = value;
            update();
        }
    }

    /**
     * Максимальное количество строк.
     * @return Если фактическое количество строк больше заданного, то текст обрезвается и добавляется в конец "..."
     *
     */
    public function get maxLinesNum():int {
        return _maxLinesNum;
    }

    public function set maxLinesNum(value:int):void {
        if (_maxLinesNum != value) {
            _maxLinesNum = value;
            update();
        }
    }

    /**
     *  @inheritDoc
     *
     */
    override public function resize(width:int, height:int):void {
//		trace("resize")
//		trace("     old Width: " + _width);
//		trace("     new Width: " + width);
        if (_width != width) {
            _width = width;

            update();
        }
    }

    /**
     * Перенос текста внутри слов.
     * @return Если true - перенос текста внутри слов, а false - перенос текста по пробелам.
     *
     */
    public function get anyBreak():Boolean {
        return _anyBreak;
    }

    public function set anyBreak(value:Boolean):void {
        if (_anyBreak != width) {
            _anyBreak = value;
            ef = ef.clone();
            ef.breakOpportunity = _anyBreak ? BreakOpportunity.ANY : BreakOpportunity.AUTO;
        }
    }

    private function myEvent_clickHandler(event:MouseEvent):void {
        var line:TextLine = event.target as TextLine;
        var region:TextLineMirrorRegion = line.getMirrorRegion(myEvent);
        trace(region.element.userData, "click!!!");
        trace("ContentElement.text =", region.element.text);
        navigateToURL(new URLRequest(region.element.userData), "_blank");
    }

    private function mouseOverHandler(event:MouseEvent):void {
//        Mouse.cursor = MouseCursor.HAND;
        CursorManager.cursorType = CursorManager.HAND;
    }

    private function mouseOutHandler(event:MouseEvent):void {
//        Mouse.cursor = MouseCursor.ARROW;
        CursorManager.cursorType = CursorManager.ARROW;
    }
}
}
