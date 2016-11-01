package chipura.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import button.BtnPotPut;
	import buttons.BtnSlotPot;
	import sprite.MenuPots;
	
	import chipura.assets.Assets;
	import chipura.pots.ClayPot;
	import chipura.pots.DreamPot;
	import chipura.pots.OwlPot;
	import chipura.pots.Pot;
	import chipura.pots.PrettyPot;
	
	
	/**
	 * Класс меню СКЛАДа
	 * @author Nataly Chipura
	 */
	public class MenuStorage extends ModalMenu 
	{
		// Размеры слота под товары
		private const SLOT_WIDTH:uint = 163;
		private const SLOT_HEIGHT:uint = 196;
		
		// Набор горшков по категориям (ключ - категория)
		private var pots:Array = new Array();
		
		/**
		 * Выбранный горшок
		 */
		private var _selectPot:Pot;
		
		// Набор кнопок выбора горшка с привязкой к Горшку
		private var potBtns:Dictionary = new Dictionary();
		
		// количество строк и столбцов слотов товаров в меню
		private var cntCol:uint = 3;
		private var cntRow:uint = 2;
		
		public function MenuStorage() 
		{
			super();

			// инициализируем набор горшков категории Маленькие Горшки
			// в реальной игре эти данные скорее всего считываются из вне (XML, данные с сервера)
			pots[Assets.POT_CAT_SMALL] = [Assets.POT_TYPE_CLAY, Assets.POT_TYPE_PRETTY, Assets.POT_TYPE_DREAM,  Assets.POT_TYPE_OWL];
		}
		
		/**
		 * Открывает вкладку меню с соответствующей категорией Горшков
		 * @param	selectCat - выбранная категория
		 */	
		public function openTabPot(selectCat:String):void {

			// формируем группу спрайтов горшков
			var groupPots:Sprite = new Sprite();
			
			var pot:Pot;
			var btnGetPot:BtnPotPut;
			
			var i:uint = 0;
			var j:uint = 0;
			
			for each(var typePot:String in pots[selectCat]) {
				
				switch(typePot) {
					case Assets.POT_TYPE_CLAY: { pot = new ClayPot(); } break;
					case Assets.POT_TYPE_PRETTY: { pot = new PrettyPot(); } break;
					case Assets.POT_TYPE_DREAM: { pot = new DreamPot(); } break;
					case Assets.POT_TYPE_OWL: { pot = new OwlPot(); } break;
				}
				
				switch(pot.status) {
					case Assets.POT_STATUS_BLOCK: {
						// выводим элемент интерфейса блокировки
					}break;
					case Assets.POT_STATUS_NEED_BUY: {
						// выводим кнопку купить
					}break;
					case Assets.POT_STATUS_AVAILABLE: {
						// выводим кнопку поместить
						btnGetPot = new BtnPotPut();		
						btnGetPot.x = i * SLOT_WIDTH;
						btnGetPot.y = j * SLOT_HEIGHT;
						groupPots.addChild(btnGetPot);
						
						btnGetPot.addEventListener(MouseEvent.CLICK, onSelectPot);

						// привязка кнопки "поместить" к гошку
						potBtns[btnGetPot] = pot;
					}break;

				}
				i++;
				if (i % cntCol == 0) {
					i = 0;
					j = (j < cntRow)?j + 1 : 0;
				} 
			}
			
			groupPots.x = -84;
			groupPots.y =  72;
			addChild(groupPots);	
		}
		
		/**
		 * Сбрасываем выбранный горшок
		 */
		public function resetPot():void 
		{
			_selectPot = null;
		}
		
		/**
		 * Получаем выбранный горшок
		 * @param	e
		 */
		private function onSelectPot(e:MouseEvent):void 
		{
			_selectPot = potBtns[(e.target as BtnPotPut)];
			dispatchEvent(new Event(Assets.EVENT_MODALMENU_GETPOT));
			onCloseMenu(e);
		}
		
		/////////////////////// GETTERs && SETTERs ///////////////////////////
		
		public function get selectPot():Pot 
		{
			return _selectPot;
		}
		
	}

}