package chipura 
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import movieClip.Slot;
	import buttons.BtnSlotPot;
	
	import chipura.assets.Assets;
	
	/**
	 * Класс Слота
	 * @author Nataly Chipura
	 */
	public class SlotManager extends Sprite 
	{
		// спрайт слота
		private var mcSlot:Slot;
		// кнопка получения горшка
		private var btnGetPot:BtnSlotPot;
		// область реагирования на мышь
		private var hitArea:Sprite;
		// ID таймера появления кнопки
		private var timerActive:uint;
		
		/**
		 * Содержимое слота
		 */
		private var _content:DisplayObject;
		/**
		 * Флаг доступности слота
		 */
		private var _flAvailable:Boolean;
		
		/**
		 * Конструктор слота 
		 * @param	width - ширина
		 * @param	height - высота
		 */
		public function SlotManager(width:uint, height:uint) 
		{
			super();

			hitArea = new Sprite();
			hitArea.graphics.beginFill(0x000000,0.0);
            hitArea.graphics.drawRect(-width / 2, -height+20, width, height);
            hitArea.graphics.endFill();
	
			addChild(hitArea);
					
			addEventListener(MouseEvent.MOUSE_OVER, onSlotOver);
			addEventListener(MouseEvent.MOUSE_OUT, onSlotOut);
			addEventListener(MouseEvent.CLICK, onSlotClick);
			addEventListener(MouseEvent.MOUSE_UP, onSlotClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onTakeContent);
			
		}
		
		/**
		 * Получение содержимого слота
		 * @param	e
		 */
		private function onTakeContent(e:MouseEvent):void 
		{
			// если есть содержимое и слот доступен, то освобождаем его
			if (content && flAvailable){
				dispatchEvent(new Event(Assets.EVENT_SLOT_FREEDUP));
				_content = null;
			}
			
		}
		
		/**
		 * Нажатие на слот
		 * @param	e
		 */
		private function onSlotClick(e:MouseEvent):void 
		{
			// если слот доступен, то создаем событие для помещения в него содержимого
			if(flAvailable){
				dispatchEvent(new Event(Assets.EVENT_SLOT_PUSH, true));
			}
		}
		
		/**
		 * Отведение мышки со слота
		 * @param	e
		 */
		private function onSlotOut(e:MouseEvent):void 
		{
			// проверяем вышли ли за область слота
			if (mcSlot!=null && !mcSlot.hitTestPoint(stage.mouseX,stage.mouseY) ) {
				hide();
			}
			
			dispatchEvent(new Event(Assets.EVENT_SLOT_OUT));
		}
		
		/**
		 * Показать индикатор слота
		 * @param	flActive - активный режим (показываем кнопку добавления горшка)
		 */
		public function show(flActive:Boolean = true):void 
		{
			if(mcSlot==null){
				mcSlot = new Slot();
				hitArea.addChild(mcSlot);
				
				if (flActive ) {
					timerActive = setTimeout(showBtn, Assets.SLOT_TIME_SHOWBTN * 1000);
				}
			}
		}
		
		/**
		 * Спрятать индикатор слота
		 */
		public function hide():void 
		{
			clearTimeout(timerActive);
			
			if (mcSlot != null) {
				hitArea.removeChild(mcSlot);
				mcSlot = null;
			}

		}
		
		/**
		 * Показать кнопу добавления горшка
		 */
		private function showBtn():void 
		{
			if (mcSlot == null) {
				show();
			}
			
			mcSlot.gotoAndStop("frArrow");
			btnGetPot = new BtnSlotPot();
			btnGetPot.y -= mcSlot.height+5;
			mcSlot.addChild(btnGetPot);
			
			btnGetPot.addEventListener(MouseEvent.MOUSE_DOWN,onGetPot)
		}
		
		/**
		 * Получить горшок
		 * @param	e
		 */
		private function onGetPot(e:MouseEvent):void 
		{
		//	hide();
			dispatchEvent(new MouseEvent(Assets.EVENT_SLOT_GETPOT));
		}
		
		/**
		 * Наведение мыши на слот
		 * @param	e
		 */
		private function onSlotOver(e:Event):void 
		{
			if(content){
				Sprite(content).buttonMode = flAvailable;
				Sprite(content).useHandCursor = flAvailable;
			}
			dispatchEvent(new Event(Assets.EVENT_SLOT_OVER));
		}
		
		////////////////////// GETTERs && SETTERs //////////////////////////
		
		public function get content():DisplayObject 
		{
			return _content;
		}
		
		public function set content(value:DisplayObject):void 
		{
			_content = value;
			addChild(value);
		}
		
		public function get flAvailable():Boolean 
		{
			return _flAvailable;
		}
		
		public function set flAvailable(value:Boolean):void 
		{
			_flAvailable = value;
		}
		
	}

}