package chipura 
{
	import chipura.assets.Assets;
	/**
	 * Класс пользователя (сохраняем, загружаем прогресс игры и храним личные данные)
	 * @author Nataly Chipura
	 */
	public class User 
	{
		private static var _instance:User;
		/**
		 * Достигнутый уровень
		 */
		private static var _level:uint;
		/**
		 * Количество приглашенных друзей
		 */
		private static var _cntFriends:uint = 0;
		  
		public function User() 
		{
			if (_instance) throw new Error ("Class is singleton!");
		}
		
		static public function get instance():User 
		{
			if (!_instance) _instance = new User();
			return _instance;
		}
		
		static public function get level():uint 
		{
			// в реальной игре уровень считывается из сохранненных данных
			return Assets.USER_LEVEL;
		}
		
		static public function get cntFriends():uint 
		{
			return _cntFriends;
		}
		
	}

}