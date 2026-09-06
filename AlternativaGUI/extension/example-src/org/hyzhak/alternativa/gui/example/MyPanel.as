package org.hyzhak.alternativa.gui.example
{
	import alternativa.gui.base.GUIobject;
	
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	/**
	 * 
	 * @project	Project AlternativaGUI Extension
	 * 
	 * @data	Mar 11, 2012 / 10:34:18 PM
	 * 
	 * @author	Eugene Krevents aka Hyzhak 
	 * 
	 */
	
	public class MyPanel extends GUIobject
	{
		public function MyPanel()
		{
			var g : Graphics = graphics;
			g.beginFill(0xffffff * Math.random());
			g.drawRect(0, 0, 200, 200);
			g.endFill();
			
			var tf : TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = name;
			addChild(tf);
		}		
	}
}