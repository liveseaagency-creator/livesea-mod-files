livesea_restart_map()
{
    players = GetPlayers();

    for(i = 0; i < players.size; i++)
    {
        p = players[i];

        if(!isDefined(p))
            continue;

        if(isDefined(p.livesea_restart_hud))
            p.livesea_restart_hud destroy();

        hud = NewClientHudElem(p);
        p.livesea_restart_hud = hud;

        hud.alignX = "center";
        hud.alignY = "middle";
        hud.horzAlign = "center";
        hud.vertAlign = "middle";

        hud.x = 0;
        hud.y = -100;

        hud.fontScale = 2.8;
        hud.alpha = 1;

        hud.color = (1, 0, 1);
    }

    for(count = 5; count > 0; count--)
    {
        foreach(p in players)
        {
            if(isDefined(p.livesea_restart_hud))
            {
                p.livesea_restart_hud setText("RESET COMPLET DANS " + count);
            }
        }

        wait 1;
    }

    map_restart(0);
}