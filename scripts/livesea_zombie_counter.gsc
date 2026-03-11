#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
    level thread livesea_monitor_players();
    level thread livesea_welcome_message();
}

livesea_welcome_message()
{
    wait 2;

    players = getentarray("player","classname");

    foreach(p in players)
    {
        if(!isdefined(p))
            continue;

        p thread livesea_welcome_hud();
    }
}

livesea_welcome_hud()
{
    self endon("disconnect");

    hud = newHudElem(self);

    hud.horzAlign = "center";
    hud.vertAlign = "top";
    hud.alignX = "center";
    hud.alignY = "top";

    hud.x = 0;
    hud.y = 40;

    hud.fontScale = 2.2;
    hud.alpha = 0;

    hud setText("^7Merci de faire partie de ^5LiveSea Agency^7 <3");

    hud fadeOverTime(0.6);
    hud.alpha = 1;

    wait 6;

    hud fadeOverTime(1);
    hud.alpha = 0;

    wait 1;

    hud destroy();
}

livesea_monitor_players()
{
    for (;;)
    {
        players = getentarray("player", "classname");

        foreach (p in players)
        {
            if (!isdefined(p))
                continue;

            if (!isdefined(p.livesea_hud_started))
            {
                p.livesea_hud_started = true;
                p thread livesea_hud();
            }
        }

        wait 1;
    }
}

livesea_hud()
{
    self endon("disconnect");

    zombieLabel = newHudElem(self);
    zombieLabel.horzAlign = "fullscreen";
    zombieLabel.vertAlign = "fullscreen";
    zombieLabel.alignX = "left";
    zombieLabel.alignY = "top";
    zombieLabel.x = 5;
    zombieLabel.y = 325;
    zombieLabel.fontScale = 1.7;
    zombieLabel.alpha = 1;

    for (;;)
    {
        remaining = livesea_get_remaining();

        if (remaining < 0)
            remaining = 0;

        if (remaining <= 5)
            zombieLabel.color = (0,1,0);
        else if (remaining <= 15)
            zombieLabel.color = (1,1,0);
        else
            zombieLabel.color = (1,0,0);

        zombieLabel setText("Zombies restants : " + remaining);

        wait 0.1;
    }
}

livesea_get_remaining()
{
    aliveArray = get_round_enemy_array();

    if (!isdefined(aliveArray))
        enemiesAlive = 0;
    else
        enemiesAlive = aliveArray.size;

    totalLeft = 0;

    if (isdefined(level.zombie_total))
        totalLeft = level.zombie_total;

    return enemiesAlive + totalLeft;
}