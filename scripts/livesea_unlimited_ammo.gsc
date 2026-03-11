#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
    level.livesea_ammo_active = false;
    level.livesea_ammo_endtime = 0;
    level.livesea_next_ammo = 0;
}

livesea_trigger_unlimited_ammo()
{
    now = gettime();

    if (now < level.livesea_next_ammo)
        return;

    level.livesea_next_ammo = now + 200;

    livesea_activate_or_extend_ammo(30);
}

livesea_activate_or_extend_ammo(seconds)
{
    now = gettime();

    if (level.livesea_ammo_active)
    {
        level.livesea_ammo_endtime += seconds * 1000;
        return;
    }

    level.livesea_ammo_active = true;
    level.livesea_ammo_endtime = now + seconds * 1000;

    level thread livesea_ammo_timer();

    players = getentarray("player","classname");

    foreach(p in players)
    {
        if (!isdefined(p))
            continue;

        p thread livesea_ammo_loop();
        p thread livesea_ammo_hud();
    }
}

livesea_ammo_loop()
{
    self endon("disconnect");

    while(level.livesea_ammo_active)
    {
        wait 0.05;

        weapon = self getcurrentweapon();

        if(!isdefined(weapon))
            continue;

        clip = self getweaponammoclip(weapon);
        max = weaponclipsize(weapon);

        if(clip < max)
            self setweaponammoclip(weapon, max);
    }
}

livesea_ammo_timer()
{
    while(level.livesea_ammo_active)
    {
        wait 0.1;

        if(gettime() >= level.livesea_ammo_endtime)
        {
            level.livesea_ammo_active = false;
            return;
        }
    }
}

livesea_ammo_hud()
{
    self endon("disconnect");

    if (isdefined(self.livesea_ammo_hud))
        return;

    hud = newClientHudElem(self);
    self.livesea_ammo_hud = hud;

    hud.horzAlign = "center";
    hud.vertAlign = "bottom";
    hud.alignX = "center";
    hud.alignY = "bottom";

    hud.x = 0;
    hud.y = -110;

    hud.font = "hudbig";
    hud.fontScale = 2.0;

    hud.color = (1,1,0);
    hud.alpha = 1;

    hud.label = &"MUNITIONS ILLIMITÉES : ";

    while(level.livesea_ammo_active)
    {
        remaining = int((level.livesea_ammo_endtime - gettime()) / 1000);

        if (remaining <= 0)
            break;

        hud setTimer(remaining);

        wait 1;
    }

    hud destroy();
    self.livesea_ammo_hud = undefined;
}