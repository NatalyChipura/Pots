package chipura 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import chipura.assets.Assets;
	import chipura.pots.Pot;
	
	/**
	 * Класс контейнера для переноса экранных объектов
	 * @author Nataly Chipura
	 */
	public class DragBox extends Sprite 
	{
		// допустимая разница координат относительно точки перемещения
		private const DIF_TOLERANCE:uint = 5;
		// время движения к точке перемещения
		private const TIME_MOVE:Number = 10;
		
		// точка, к которой нужно переместиться
		private var ptTarget:Point;
		// вектор перемещения
		private var vx:Number;
		private var vy:Number;
		// скорость перемещения
		private var speed:Number;
		
		/**
		 * Содержимое контейнера
		 */
		private var _content:DisplayObject;
		
		public function DragBox() 
		{
			super();
			
			mouseEnabled = false;
		
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		/**
		 * Удаление контейнера с экрана
		 * @param	e
		 */
		private function onRemove(e:Event):void 
		{
			//	trace("DragBoxRemove");
			
			_content = null;
			removeChildren();
			removeEventListener(Assets.EVENT_DRAGBOX_DROP, onDrop);
		
		}
		
		/**
		 * Добавление контейнера на экран
		 * @param	e
		 */
		private function onAdd(e:Event):void 
		{
		//	trace("AddDragBox");
			
			mouseChildren = false;
			
			startDrag();
			addEventListener(Assets.EVENT_DRAGBOX_DROP, onDrop);
		}
		
		/**
		 * Отпускание контейнера
		 * @param	e
		 */
		private function onDrop(e:Event):void 
		{
			stopDrag();
			removeEventListener(Assets.EVENT_DRAGBOX_DROP, onDrop);
			
			mouseChildren = true;
			
			content.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		/**
		 * Перемещение к точке
		 * @param	cx - координата x
		 * @param	cy - координата y
		 */
		public function moveToPoint(cx:Number,cy:Number):void {
			ptTarget = new Point(cx, cy);
			speed = Point.distance(ptTarget, new Point(x, y))/TIME_MOVE;
			addEventListener(Event.ENTER_FRAME, onMove);
			
		}
		
		/**
		 * Обрабатываем движение
		 * @param	e
		 */
		private function onMove(e:Event):void 
		{
			
			if(!move()){
				// если достигли целевой точки то убираем контейнер
				removeEventListener(Event.ENTER_FRAME, onMove);
				dispatchEvent(new Event(Assets.EVENT_DRAGBOX_LEAVE));
			}
			
		}
		
		/**
		 * Движение - изменение координат
		 * @return - соответствуют ли координаты целевой точки с допустимым отклонением
		 */
		public function move():Boolean {
			var difY:int = ptTarget.y - y;
			var difX:int = ptTarget.x - x;
						
			var radians:Number = Math.atan2(difY, difX);
			var speedX:Number = speed * Math.cos(radians);
			var speedY:Number = speed * Math.sin(radians);
			x = (Math.abs(difX) <= DIF_TOLERANCE) ? ptTarget.x : (x + speedX);
			y = (Math.abs(difY) <= DIF_TOLERANCE) ? ptTarget.y : (y + speedY);
			
			return (ptTarget.x!=x && ptTarget.y!=y) 
		}
		
		///////////////////// GETTERs && SETTERs ///////////////////////////////////
		public function isActive():Boolean 
		{
			return numChildren > 0;
		}
		
		public function get content():DisplayObject 
		{
			return _content;
		}
		
		public function set content(value:DisplayObject):void 
		{
			_content = value;
			addChild(_content);
		}
	}

}