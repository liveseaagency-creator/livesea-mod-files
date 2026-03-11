#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
    level.livesea_invincible_active = false;
    level.livesea_invincible_endtime = 0;
    level.livesea_next_invincible = 0;
}

livesea_trigger_invincible()
{
    now = gettime();

    if (now < level.livesea_next_invincible)
        return;

    level.livesea_next_invincible = now + 250;

    livesea_activate_or_extend_invincible(60);
}

livesea_activate_or_extend_invincible(seconds)
{
    now = gettime();

    if (level.livesea_invincible_active)
    {
        level.livesea_invincible_endtime += seconds * 1000;
        return;
    }

    level.livesea_invincible_active = true;
    level.livesea_invincible_endtime = now + seconds * 1000;

    level thread livesea_invincible_timer();

    players = getentarray("player","classname");

    foreach(p in players)
    {
        if (!isdefined(p))
            continue;

        if (!isplayer(p))
            continue;

        p thread livesea_invincible_protect();
        p thread livesea_invincible_hud();
    }
}

livesea_invincible_timer()
{
    while(level.livesea_invincible_active)
    {
        wait 0.1;

        if (gettime() >= level.livesea_invincible_endtime)
        {
            level.livesea_invincible_active = false;
            return;
        }
    }
}

livesea_invincible_protect()
{
    self endon("disconnect");

    self.maxhealth = self.health;

    while(level.livesea_invincible_active)
    {
        self waittill("damage", damage, attacker, direction, point, type);
        self.health = self.maxhealth;
    }
}

livesea_invincible_hud()
{
    self endon("disconnect");

    if (isdefined(self.livesea_invincible_hud))
        return;

    hud = newClientHudElem(self);
    self.livesea_invincible_hud = hud;

    hud.horzAlign = "center";
    hud.vertAlign = "bottom";
    hud.alignX = "center";
    hud.alignY = "bottom";

    hud.x = 0;
    hud.y = -50;

    hud.font = "hudbig";
    hud.fontScale = 2.0;

    hud.color = (0.4,0.8,1); // bleu ciel
    hud.alpha = 1;

    hud.label = &"INVINCIBLE : ";

    while(level.livesea_invincible_active)
    {
        remaining = int((level.livesea_invincible_endtime - gettime()) / 1000);

        if (remaining <= 0)
            break;

        hud setTimer(remaining);

        wait 1;
    }

    hud destroy();
    self.livesea_invincible_hud = undefined;
}