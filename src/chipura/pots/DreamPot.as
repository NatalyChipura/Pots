package chipura.pots 
{
	import chipura.assets.Assets;
	import sprite.Pot2;
	/**
	 * Класс Горшок Мечта цветовода
	 * @author Nataly Chipura
	 */
	public class DreamPot extends Pot 
	{
		
		public function DreamPot() 
		{
			super("Мечта цветовода", 6, Assets.TYPE_GET_LEVEL);
			sprite = new Pot2();
			saveStatus = Assets.POT_STATUS_AVAILABLE;
			
		}
		
	}

}