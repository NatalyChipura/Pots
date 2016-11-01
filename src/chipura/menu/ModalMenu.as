package chipura.menu 
{
	import chipura.assets.Assets;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sprite.MenuPots;
	
	/**
	 * Родительский класс для модальных меню
	 * @author Nataly Chipura
	 */
	public class ModalMenu extends Sprite 
	{
		// кнопка закрытия
		private var btnClose:SimpleButton;
	
		// спрайт меню
		private var menu:MenuPots;
		
		public function ModalMenu() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
	
		}
		
		protected function onAdd(e:Event):void 
		{
			menu = new MenuPots();
			addChildAt(menu,0);
			
			var hitBtn:Shape = new Shape();
			hitBtn.graphics.beginFill(0x000000, 1.0);
			hitBtn.graphics.drawRect(0, 0, 30, 30);
			hitBtn.graphics.endFill();
			
			var btnClose:SimpleButton = new SimpleButton(null, null, null, hitBtn);
			btnClose.addEventListener(MouseEvent.MOUSE_DOWN, onCloseMenu);
			btnClose.x = menu.width/2 - hitBtn.width -15;
			btnClose.y = -menu.height/2 + hitBtn.height/2;
			menu.addChild(btnClose);
		}
		
		/**
		 * Закрываем меню
		 * @param	e
		 */
		protected function onCloseMenu(e:MouseEvent):void 
		{
			removeChildren();
			dispatchEvent(new Event(Assets.EVENT_MODALMENU_CLOSE));
		}
		
	}

}