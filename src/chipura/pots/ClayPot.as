package chipura.pots 
{
	import chipura.assets.Assets;
	import sprite.Pot1;
	/**
	 * Класс Глинянный горшок
	 * @author Nataly Chipura
	 */
	public class ClayPot extends Pot 
	{
		
		public function ClayPot() 
		{
			super("Глинянный горшок", 1, Assets.TYPE_GET_LEVEL);
			
			sprite = new Pot1();
			
			saveStatus = Assets.POT_STATUS_AVAILABLE;
			
		}
		
	}

}