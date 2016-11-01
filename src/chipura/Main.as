package chipura
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import chipura.assets.Assets;
	import chipura.menu.MenuStorage;
	import chipura.pots.ClayPot;
	import chipura.pots.DreamPot;
	import chipura.pots.Pot;
	
	import movieClip.Slot;
	import button.BtnStorage;
	import sprite.MenuPots;
	import sprite.Sill;
	
	/**
	 * Главный класс игры
	 * @author Nataly Chipura
	 */
	public class Main extends Sprite 
	{
		private var btnStorage:BtnStorage;		// кнопка СКЛАД
		private var menuStorage:MenuStorage;	// модальное окно с горшками (меню СКЛАД)
		private var sill:Sill;					// подоконник
		
		private var selectSlot:SlotManager;		// выбранный слот для помещения горшка через кнопку в слоте
		private var freedSlot:SlotManager;		// освободившийся слот, с которого взяли горшок
		private var overSlot:SlotManager;		// слот в фокусе мышки
		
		private var dragBox:DragBox;			// контейнер для перемещения экранных объектов (в частности горшков)
		
		private var flhaveFreeSlot:Boolean = false; // флаг для создания хотя бы одного пустого слота
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createInterface();
			initGame();
		}
				
		/**
		 * Создаем интерфейс
		 */
		private function createInterface():void 
		{
			// добавляем фон
			Assets.fonBitmap.width = stage.stageWidth;
			Assets.fonBitmap.height = stage.stageHeight;
			addChildAt(Assets.fonBitmap, 0);

			// инициализируем меню СКЛАД
			menuStorage = new MenuStorage();
			menuStorage.x = stage.stageWidth / 2;
			menuStorage.y = stage.stageHeight / 2;
			
			// добавляем кнопку СКЛАД
			btnStorage = new BtnStorage();
			// центрируем кнопку в нижнем меню в отведенной для нее области
			btnStorage.x = stage.stageWidth - (Assets.AREA_BTN_STORAGE * stage.stageWidth) / 2;
			btnStorage.y = stage.stageHeight - Assets.AREA_MENU_BOTTOM / 2;
			addChild(btnStorage);
			btnStorage.addEventListener(MouseEvent.MOUSE_DOWN, onOpenMenuStorage);
			
			// создаем контейнер для перетаскивания
			dragBox = new DragBox();
		}
	
		/**
		 * Инициализируем игровые параметры
		 */
		private function initGame():void 
		{
			// создаем подоконник
			sill = new Sill();
			sill.x = Assets.POS_SILL_X;
			sill.y = Assets.POS_SILL_Y;
			sill.visible = false;
			addChild(sill);
			
			// инициализируем слоты подоконника
			var wCentrSill:Number = sill.width * 0.9;
			var wSlot:Number = wCentrSill / Assets.SLOT_COUNT;
			var pos:Point = new Point(sill.x + (sill.width - wCentrSill)/2 + wSlot/2,sill.y + sill.height / 2)
		
			for (var i:uint = 0; i < Assets.SLOT_COUNT; i++) {
				// заполняем слот (горшком или оставляем пустым)
				addChild(initSlot(pos.x + i * wSlot, pos.y,wSlot));
			}
		}
				
		/**
		 * Инициализируем слот (в реальной игре подгружаем прогресс игры, в тестовом задании - размещаем случайным образом горшки)
		 */
		private function initSlot(px:Number,py:Number,wSlot:uint):Sprite
		{
			var slot:SlotManager;
			// определяем будет ли слот пустой
			var typeSlot:uint = (flhaveFreeSlot?Math.ceil(Math.random() * (Assets.POT_AVAILABLE_COUNT + 1)):(Assets.POT_AVAILABLE_COUNT + 1));
					
			//добавляем индикатор слота
			slot = new SlotManager(wSlot, 1.2*wSlot);
			slot.addEventListener(Assets.EVENT_SLOT_PUSH, onPutPot);
			slot.addEventListener(Assets.EVENT_SLOT_GETPOT, onSelectSlot);
			slot.addEventListener(Assets.EVENT_SLOT_OVER, onSlotOver);
			slot.addEventListener(Assets.EVENT_SLOT_OUT, onSlotOut);
			slot.addEventListener(Assets.EVENT_SLOT_FREEDUP, onTakePotforRemove);
			slot.x = px;
			slot.y = py;
			
			if (typeSlot > Assets.POT_AVAILABLE_COUNT) {
				flhaveFreeSlot = true;		// свободный слот
			} else {
				// горшок
				var pot:Pot;
				switch(typeSlot){
					case 1: pot = new ClayPot(); break;
					case 2: pot = new DreamPot(); break;
				}
				
				addPotToSlot(pot, slot);
			}
			
			return slot;
		}

		/**
		 * Добавляем горшок на слот
		 * @param	pot - горшок
		 * @param	slot - слот
		 */
		private function addPotToSlot(pot:Pot,slot:SlotManager):void {
			slot.content = pot;
		}

		/**
		 * Поместить объект в контейнер для перетаскивания
		 * @param	obj - экранный объект
		 */
		private function pushInDragBox(obj:DisplayObject):void {
			sill.visible = true;
			
			// добавляем контейнер
			addChild(dragBox);
			
			// добавляем событие отпускания контейнера мышкой и клавишей ESC
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropDragbox);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			
			// привязываем к координатам мыши
			dragBox.x = stage.mouseX;
			dragBox.y = stage.mouseY;
			obj.x = obj.y = 0;
			
			// помещаем объект в контейнер
			dragBox.content = obj;
			
			stage.focus = this;
		}
		
		/**
		 * Бросаем контейнер объектов
		 * @param	e
		 */
		private function onDropDragbox(e:Event):void 
		{
		    // trace("onDropDragbox");
		
			// Проверяем доступен ли слот для размещения горшка, либо горшок брошен вне подоконника
			if(overSlot==null || overSlot.flAvailable){
				dragBox.dispatchEvent(new Event(Assets.EVENT_DRAGBOX_DROP));
		
				var pot:Pot = dragBox.content as Pot;
			
				// если горшок брошен вне подоконника, то отправляем его назад (на прежний слот или к кнопке меню)
				if (freedSlot) {
					dragBox.moveToPoint(freedSlot.x, freedSlot.y);
				} else {
					dragBox.moveToPoint(btnStorage.x, btnStorage.y);
				}
			
				dragBox.addEventListener(Assets.EVENT_DRAGBOX_LEAVE, onDragboxLeave);
			}
		}
		
		/**
		 * Контейнер объектов добрался до точки возврата (покинул игру)
		 * @param	e
		 */
		private function onDragboxLeave(e:Event):void 
		{
			var pot:Pot = dragBox.content as Pot;
			if (freedSlot) {
				// помещаем горшок на прежний слот
				addPotToSlot(pot, freedSlot);
			} else {
				// сбрасываем значение выбранного в меню горшка
				menuStorage.resetPot();	
			}
			
			removeDragbox();
			dragBox.removeEventListener(Assets.EVENT_DRAGBOX_LEAVE, onDragboxLeave);
			
		}
		
		/**
		 * Убираем контейнер для перетаскивания объектов
		 */
		private function removeDragbox():void {
			sill.visible = false;
			removeChild(dragBox);	
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropDragbox);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}

		/**
		 * Берём горшок для перетаскивания из слота
		 * @param	e
		 */
		private function onTakePotforRemove(e:Event):void 
		{	
			var slot:SlotManager = (e.target as SlotManager);
			pushInDragBox(Pot(slot.content)); // помещаем взятый горшок в контейнер
			freedSlot = slot;				  // запоминаем освободившийся слот
		}
		
		/**
		 * Помещаем горшок на слот
		 * @param	e
		 */
		private function onPutPot(e:Event):void 
		{
		//	trace("ONputPot");
			
			// вытаскиваем горшок из контейнера
			var pot:Pot = Pot(dragBox.content);
			if(pot!=null){
				// определяем слот для размещения (либо тот, что выбран кнопкой на слоте, либо - на который наводим мышь)
				var slot:SlotManager = selectSlot==null?(e.target as SlotManager):selectSlot;
				
				// убираем контейнер
				removeDragbox();
				
				if (slot.content) {
					// если слот занят другим горшком помещам в контейнер горшок со слота
					pushInDragBox(slot.content);
				} else {
					// если слот свободен, очищаем значение осободившегося слота
					freedSlot = null;
				}

				// помещаем перетаскиваемый горшок на слот
				addPotToSlot(pot, slot);
				
				// сбрасываем значение выбранного в меню горшка
				menuStorage.resetPot();
			
				// прячем индикатор слота				
				slot.hide();
				selectSlot = null;
			}
		}
		
		/**
		 * Наведение мышки на слот
		 * @param	e
		 */
		private function onSlotOver(e:Event):void 
		{
			// запоминаем наведенный слот
			overSlot = e.target as SlotManager;
			
			// проверяем доступен ли слот для размещения горшка, и нужно ли показывать стрелку
			overSlot.flAvailable = true;
			if (menuStorage.selectPot == null && overSlot.content == null && dragBox.content == null) {
				overSlot.show();
			} else if (menuStorage.selectPot != null && overSlot.content == null) {
				overSlot.show(false);
			} else if (menuStorage.selectPot == null && dragBox.content != null) {
				overSlot.show(false);
			} else if (menuStorage.selectPot != null && overSlot.content != null) {
				overSlot.flAvailable = false;
			}
		}
		
		/**
		 * Уведение курсора со слота
		 * @param	e
		 */
		private function onSlotOut(e:Event):void 
		{
			overSlot = null;
		}
		
		/**
		 * Инициализация выбранного слота для размещения горшка по кнопке на слоте
		 * @param	e
		 */
		private function onSelectSlot(e:MouseEvent):void 
		{
			selectSlot = e.target as SlotManager;
			onOpenMenuStorage(e);
		}
		
		/**
		 * Получение горшка в меню
		 * @param	e
		 */
		private function onGetPot(e:Event):void 
		{
		//	trace("Pot was get",menuStorage.selectPot);
		
			pushInDragBox(menuStorage.selectPot);
			
			// если есть выбранный слот, сразу размещаем горшок туда
			if (selectSlot) {
				onPutPot(e);
			}
			
		}
		
		/**
		 * Открываем меню СКЛАД
		 * @param	e
		 */
		private function onOpenMenuStorage(e:MouseEvent):void 
		{
		//	trace("Open Storage");
			
			freedSlot = null;
		
			btnStorage.mouseEnabled = false;
			
			addChild(menuStorage);
			// открываем вкладку категории маленькие горшки
			menuStorage.openTabPot(Assets.POT_CAT_SMALL);
			
			menuStorage.addEventListener(Assets.EVENT_MODALMENU_GETPOT, onGetPot);
			menuStorage.addEventListener(Assets.EVENT_MODALMENU_CLOSE, onCloseMenuStorage);
		}
		
		/**
		 * Закрываем меню СКЛАД
		 * @param	e
		 */
		private function onCloseMenuStorage(e:Event):void 
		{
		//	trace("Close Storage");
			
			menuStorage.removeEventListener(Assets.EVENT_MODALMENU_GETPOT, onGetPot);
			menuStorage.removeEventListener(Assets.EVENT_MODALMENU_CLOSE, onCloseMenuStorage);
			removeChild(menuStorage);
			
			btnStorage.mouseEnabled = true;
		}
		
				
		/**
		 * Обрабатываем нажатие клавиш
		 * @param	e - событие клавиатуры
		 */
		private function onKeyPress(e:KeyboardEvent):void 
		{
			// если нажат Esc
			if (e.keyCode == Assets.KEY_ESC) {
				if (menuStorage.selectPot != null) onDropDragbox(null);
			}
		}
		
	}
	
}