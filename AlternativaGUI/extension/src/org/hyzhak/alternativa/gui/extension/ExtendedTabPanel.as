package org.hyzhak.alternativa.gui.extension
{
	import alternativa.gui.container.tabPanel.TabData;
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.theme.defaulttheme.container.tabPanel.TabButton;
	import alternativa.gui.theme.defaulttheme.container.tabPanel.TabPanel;
	
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @project	Project Wall Builder
	 * 
	 * @data	Feb 18, 2012 / 11:29:10 AM
	 * 
	 * @author	Eugene Krevents aka Hyzhak 
	 * 
	 */
	
	public class ExtendedTabPanel extends TabPanel
	{
		
		//----------------------------------
		//  constants
		//----------------------------------
		
		//----------------------------------
		//  params 
		//----------------------------------
		private var _emptyTab:EmptyTab;
		
		//----------------------------------
		//  constructor 
		//----------------------------------

		
		public function ExtendedTabPanel()
		{
			super();
			addEmptyTab();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Main API
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Add
		//----------------------------------

		/**
		 * Add content in tabPanel 
		 *  
		 * @param content	content
		 * @param label		text added to label
		 * 
		 */
		public function addTabPanel(content : DisplayObject, label : String = null) : void
		{
			if(label == null)
			{
				label = content.name;
			}
			
			var tabButton:TabButton = new TabButton();
			tabButton.label = label;
			addTab(new TabData(tabButton, content));
			
			width = content.width;
			height = content.height;
			
			refresh()
		}
		
		/**
		 * Add Tab
		 *  
		 * @param object
		 * 
		 */
		override public function addTab(object:TabData):void 
		{
			super.addTab(object);
			
			if(object.content != _emptyTab)
			{
				removeTabByContent(_emptyTab);
			}
		}
		
		//----------------------------------
		//  Remove
		//----------------------------------
		
		/**
		 * Remove tab from panel at some index
		 *   
		 * @param index
		 * 
		 */
		public function removeTabAt(index : int) : void
		{
			if(index < 0)
			{
				return;
			}
			
			var isAddEmptyTab : Boolean = true;
			if(getTabContentAt(index) == _emptyTab)
			{
				if(numTabs == 1)
				{
					return;
				}
				
				isAddEmptyTab = false;
			}
			
			buttonHBox.removeChild(getTabBtn(index) as DisplayObject);
			tabData.splice(index, 1);
			
			if(isAddEmptyTab && numTabs <= 0)
			{
				addEmptyTab();
			}
			
			refresh();
		}
		
		/**
		 * Remove tab from panel by tabdata instance
		 *  
		 * @param data
		 * 
		 */
		public function removeTabData(data : TabData) : void
		{
			var index : int = getTabIndex(data);
			if(index < 0)
			{
				return;
			}
			removeTabAt(index);
		}
		
		/**
		 * Remove Tab from panel by content
		 *  
		 * @param content
		 * 
		 */
		public function removeTabByContent(content:DisplayObject):void
		{
			var data : TabData = getTabDataByContent(content);
			if(data == null)
			{
				return;
			}
			
			removeTabData(data);
		}
		
		//----------------------------------
		//  Get
		//----------------------------------
		
		/**
		 * Get number of tabs
		 *  
		 * @return 
		 * 
		 */
		public function get numTabs() : int
		{
			return tabData.length;
		}
		
		/**
		 * Get tab content by index of tab
		 *  
		 * @param index
		 * @return 
		 * 
		 */
		public function getTabContentAt(index : int) : DisplayObject
		{
			return getTabDataAt(index).content;
		}
		
		/**
		 * Get tab by index 
		 * @param index
		 * @return 
		 * 
		 */
		public function getTabDataAt(index : int) : TabData
		{
			return tabData[index];	
		}
		
		/**
		 * Get tab data by context
		 *  
		 * @param content
		 * @return 
		 * 
		 */
		public function getTabDataByContent(content : DisplayObject) : TabData
		{
			for each(var data : TabData in tabData)
			{
				if(data.content == content)
				{
					return data;
				}
			}
			
			return null;
		}
		
		/**
		 * Get tab button by index
		 *  
		 * @param index
		 * @return 
		 * 
		 */
		public function getTabBtn(index : int) : ITriggerButton
		{
			return getTabDataAt(index).button;
		}
		
		/**
		 * Get tab button label by index
		 *  
		 * @param index
		 * @return 
		 * 
		 */
		public function getTabLabel(index : int) : String
		{
			var btn : TabButton = getTabBtn(index) as TabButton;
			if(btn == null)
			{
				return "";
			}
			
			return btn.label;
		}
		
		/**
		 * Set tab button label by index 
		 * @param index
		 * @param label
		 * 
		 */
		public function setTabLabel(index : int, label : String) : void
		{
			var btn : TabButton = getTabBtn(index) as TabButton;
			if(btn == null)
			{
				return;
			}
			
			btn.label = label;
		}
		
		/**
		 * Select tab
		 *  
		 * @param index
		 * 
		 */
		override public function set selectTab(index:int):void
		{
			if(numTabs <= 0)
			{
				return;
			}
			
			var last : int = numTabs - 1;
			
			if(index > last)
			{
				index = last;
			}
			if(index < 0)
			{
				index = 0;
			}
			
			super.selectTab = index;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * hack for refresh actual view
		 * 
		 */
		private function refresh() : void
		{
			if(selectTab > 0)
			{
				selectTab--;
				selectTab++;
			}
			else
			{
				selectTab++;
				selectTab--;
			}
			
			draw();
		}
		
		/**
		 * add empty tab when tab panel is empty 
		 * 
		 */
		private function addEmptyTab() : void
		{
			_emptyTab = new EmptyTab(); 
			
			addTabPanel(_emptyTab, "");
		}
		
		private function getTabIndex(data:TabData):int
		{
			return tabData.indexOf(data);
		}
	}
}