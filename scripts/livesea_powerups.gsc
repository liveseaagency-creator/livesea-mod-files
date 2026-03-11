#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_utility;

livesea_spawn_powerup_all(powerup_name)
{
    players = getentarray("player", "classname");

    foreach (p in players)
    {
        if (!isdefined(p))
            continue;

        if (!isplayer(p))
            continue;

        pos = p.origin + (0,0,20);

        specific_powerup_drop(powerup_name, pos);

        p thread livesea_center_hud_thread(livesea_powerup_hud_text(powerup_name));
    }
}

livesea_spawn_random_powerup()
{
    powerups = getarraykeys(level.zombie_include_powerups);

    if(!isdefined(powerups) || powerups.size == 0)
        return;

    index = randomint(powerups.size);
    chosen = powerups[index];

    level thread livesea_spawn_powerup_all(chosen);
}

livesea_powerup_hud_text(powerup_name)
{
    if (powerup_name == "nuke")
        return "^1NUKE ACTIVÉ !";

    if (powerup_name == "double_points")
        return "^3POINTS DOUBLÉS !";

    if (powerup_name == "insta_kill")
        return "^1MORT INSTANTANÉE !";

    if (powerup_name == "carpenter")
        return "^5CHARPENTIER !";

    if (powerup_name == "full_ammo")
        return "^2MUNITIONS MAX !";

    if (powerup_name == "fire_sale")
        return "^6SOLDES DE LA BOITE !";

    return "^2POWERUP ACTIVÉ !";
}

livesea_center_hud_thread(text)
{
    self notify("livesea_center_text");
    self endon("livesea_center_text");
    self endon("disconnect");

    if (isdefined(self.livesea_center_hud))
        self.livesea_center_hud destroy();

    hud = newHudElem(self);
    self.livesea_center_hud = hud;

    hud.horzAlign = "center";
    hud.vertAlign = "middle";
    hud.alignX = "center";
    hud.alignY = "middle";

    hud.x = 0;
    hud.y = -40;

    hud.fontScale = 2.6;
    hud.alpha = 0;

    hud.color = (1,1,0);

    hud setText(text);

    hud fadeOverTime(0.3);
    hud.alpha = 1;

    wait 3;

    hud fadeOverTime(0.8);
    hud.alpha = 0;

    wait 0.8;

    if (isdefined(self.livesea_center_hud))
    {
        hud destroy();
        self.livesea_center_hud = undefined;
    }
}