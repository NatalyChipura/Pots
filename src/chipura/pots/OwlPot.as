package chipura.pots 
{
	import chipura.assets.Assets;
	/**
	 * Класс Горшок Совята
	 * @author Nataly Chipura
	 */
	public class OwlPot extends Pot 
	{
		
		public function OwlPot() 
		{
			super("Горшок совята", 1, Assets.TYPE_GET_FRIENDS, 3);
			saveStatus = Assets.POT_STATUS_BLOCK;
			
		}
		
	}

}