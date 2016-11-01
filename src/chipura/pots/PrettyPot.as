package chipura.pots 
{
	import chipura.assets.Assets;
	/**
	 * Класс Миленький Горшок
	 * @author Nataly Chipura
	 */
	public class PrettyPot extends Pot 
	{
		
		public function PrettyPot() 
		{
			super("Горшок Миленький", 5, Assets.TYPE_GET_LEVEL);
			saveStatus = Assets.POT_STATUS_BLOCK;
			
		}
		
	}

}