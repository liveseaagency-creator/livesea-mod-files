livesea_trigger_bonus_points(amount)
{
	players = GetPlayers();

	foreach(p in players)
	{
		if(!isDefined(p))
			continue;

		p.score += amount;

		if(!isDefined(p.livesea_points_hud))
		{
			hud = NewClientHudElem(p);
			p.livesea_points_hud = hud;

			hud.alignX = "center";
			hud.alignY = "middle";
			hud.horzAlign = "center";
			hud.vertAlign = "middle";

			hud.x = 0;
			hud.y = 0;

			hud.fontScale = 2.5;
		}

		hud = p.livesea_points_hud;
		hud.alpha = 1;

		if(amount > 0)
		{
			hud.color = (0,1,0);
			text = "+" + amount + " POINTS BONUS";
		}
		else
		{
			hud.color = (1,0,0);
			text = amount + " POINTS BONUS";
		}

		hud setText(text);

		p notify("livesea_points_update");
		p thread livesea_points_fade();
	}
}

livesea_points_fade()
{
	self endon("livesea_points_update");

	wait 2;

	if(isDefined(self.livesea_points_hud))
	{
		self.livesea_points_hud fadeOverTime(0.5);
		self.livesea_points_hud.alpha = 0;
	}
}


livesea_follow_bonus()
{
	players = GetPlayers();

	foreach(p in players)
	{
		if(!isDefined(p))
			continue;

		p.score += 150;

		hud = NewClientHudElem(p);

		hud.alignX = "center";
		hud.alignY = "top";
		hud.horzAlign = "center";
		hud.vertAlign = "top";

		hud.x = 0;
		hud.y = -5;

		hud.fontScale = 2.7;
		hud.alpha = 1;

		hud.color = (1,0.2,0.6);

		hud setText("MERCI POUR LE FOLLOW ! (+150 POINTS BONUS)");

		hud fadeOverTime(3);
		wait 2.5;
		hud.alpha = 0;
	}
}


livesea_reset_points()
{
	players = GetPlayers();

	foreach(p in players)
	{
		if(!isDefined(p))
			continue;

		p.score = 0;

		if(!isDefined(p.livesea_points_hud))
		{
			hud = NewClientHudElem(p);
			p.livesea_points_hud = hud;

			hud.alignX = "center";
			hud.alignY = "middle";
			hud.horzAlign = "center";
			hud.vertAlign = "middle";

			hud.x = 0;
			hud.y = 0;

			hud.fontScale = 2.5;
		}

		hud = p.livesea_points_hud;
		hud.alpha = 1;

		hud.color = (1,0,0);
		hud setText("POINT BONUS RESET");

		p notify("livesea_points_update");
		p thread livesea_points_fade();
	}
}