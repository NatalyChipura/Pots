package chipura.pots 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import chipura.assets.Assets;
	import chipura.User;
	
	/**
	 * Класс Горшок
	 * @author Nataly Chipura
	 */
	public class Pot extends Sprite 
	{
		/**
		 * Sprite горшка
		 */
		protected var _sprite:Sprite;
		
		// здесь описываются свойства горшка
		protected var levelGet:uint;	// уровень доступности
		protected var needCntGet:uint;	// необходимое количество чего-либо (друзей и т.п.) для получения горшка
		protected var typeGet:String;	// условие получения (количество друзей или уровень)

		/**
		 * Название горшка
		 */
		protected var _title:String;	
	
		/**
		 * Статус доступности горшка
		 */
		public var _status:String;
		
		// сохраненный статус в процессе игры. Эти данные должны получаться из вне. Данные прогресса игры.
		protected var saveStatus:String = Assets.POT_STATUS_BLOCK;

		
		public function Pot(vName:String,vLevel:uint, vTypeGet:String, vNeedGet:uint = 0) 
		{
			super();
			_title = vName;
			levelGet = vLevel;
			typeGet = vTypeGet;
		}
		
		public function buy():void {
			// производим покупку и меняем статус на доступный
			_status = Assets.POT_STATUS_AVAILABLE;	
		}
		
		////////////////////// GETTERs  && SETTERs ////////////////////////////
		
		public function get status():String 
		{
			_status = saveStatus;
			if(_status==Assets.POT_STATUS_BLOCK){
				if ((typeGet == Assets.TYPE_GET_LEVEL && levelGet >= User.level) || (typeGet == Assets.TYPE_GET_FRIENDS && needCntGet >= User.cntFriends)) {
					_status = Assets.POT_STATUS_NEED_BUY; 
				}
			}
			return _status;
		}
		
		public function get title():String 
		{
			return _title;
		}
		
		protected function set sprite(value:Sprite):void 
		{
			_sprite = value;
			addChild(_sprite);
		}
		
	}

}