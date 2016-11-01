package chipura.assets 
{
	import flash.display.Bitmap;
	/**
	 * Класс констант
	 * @author Nataly Chipura
	 */
	public class Assets 
	{
	
		/**
		 * Фоновое изображение
		 */
		[Embed (source = "../../assets/img/Back.png")]
		static private const Fon:Class;
		static public const fonBitmap:Bitmap = new Fon;

		/**
		 * Количество открытых (доступных) горшков
		 */
		static public const POT_AVAILABLE_COUNT:uint = 2;
		
		/////////////////// SLOT ///////////////////////////////////
		/**
		 * Количество слотов под горшки
		 */
		static public const SLOT_COUNT:uint = 6;
		/**
		 * Время в секундах, по истечению которого показывать кнопку добавления горшка
		 */
		static public const SLOT_TIME_SHOWBTN:uint = 2;

		////////////////// POSITIONs ///////////////////////////
		
		/**
		 * Позиция подоконника
		 */
		static public const POS_SILL_X:uint = 56; 
		static public const POS_SILL_Y:uint = 483; 
		
		/**
		 * Размер области под нижнее меню в пикселях
		 */
		static public const AREA_MENU_BOTTOM:uint = 114;
		
		/**
		 * Размер области под кнопку Склад в процентах (0..1)
		 */
		static public const AREA_BTN_STORAGE:Number = 0.2;
		
		////////////////// EVENTs ////////////////////////////
		
		static public const EVENT_MODALMENU_CLOSE:String = "EventModalMenuClose";
		static public const EVENT_MODALMENU_GETPOT:String = "EventSelectPot";
		
		static public const EVENT_SLOT_GETPOT:String = "EventGetPot";
		static public const EVENT_SLOT_PUSH:String = "EventSlotClick";
		static public const EVENT_SLOT_OVER:String = "EventSlotOver";
		static public const EVENT_SLOT_OUT:String = "EventSlotOut";
		static public const EVENT_SLOT_FREEDUP:String = "EventSlotFreedUp";
		
		static public const EVENT_DRAGBOX_DROP:String = "EventDragBoxDrop";
		static public const EVENT_DRAGBOX_LEAVE:String = "EventDragBoxLeave";
		
		/////////////////// KEYs //////////////////////////////////
		
		static public const KEY_ESC:uint = 27;
		
		////////////////// USER ////////////////////////////
		
		static public const USER_LEVEL:uint = 6;
		
		////////////////// PRODUCTs ////////////////////////////
		
		static public const TYPE_GET_FRIENDS:String = "NeedFriends";
		static public const TYPE_GET_LEVEL:String = "NeedLevel";
		
		////////////////// POTs ///////////////////////////////
		static public const POT_TYPE_CLAY:String = "ClayPot";
		static public const POT_TYPE_DREAM:String = "DreamPot";
		static public const POT_TYPE_PRETTY:String = "PrettyPot";
		static public const POT_TYPE_OWL:String = "OwlPot";
		
		static public const POT_CAT_SMALL:String = "CategorySmall";
		
		static public const POT_STATUS_BLOCK:String = "PotIsBlock";
		static public const POT_STATUS_NEED_BUY:String = "PotNeedBuy";
		static public const POT_STATUS_AVAILABLE:String = "PotIsAvailable";
		
	}

}