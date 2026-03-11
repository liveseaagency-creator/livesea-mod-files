#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;


livesea_add_zombies(amount)
{
    if (isdefined(level.livesea_add_busy) && level.livesea_add_busy)
        return;

    if (!isdefined(level.round_number))
        return;

    level.livesea_add_busy = true;

    if (!isdefined(level.zombie_total))
        level.zombie_total = 0;

    level.zombie_total += amount;

    livesea_force_spawn_wave();

    livesea_center_message("^6+" + amount + " ZOMBIES");

    level.livesea_add_busy = false;
}


livesea_force_spawn_wave()
{
    maxAI = 24;

    aliveArray = get_round_enemy_array();

    if (!isdefined(aliveArray))
        alive = 0;
    else
        alive = aliveArray.size;

    freeSlots = maxAI - alive;

    if (freeSlots <= 0)
        return;

    spawnNow = freeSlots;

    if (spawnNow > level.zombie_total)
        spawnNow = level.zombie_total;

    for (i = 0; i < spawnNow; i++)
    {
        level notify("zombie_spawn");
        wait 0.03;
    }
}


livesea_center_message(text)
{
    players = getentarray("player", "classname");

    foreach (p in players)
    {
        if (!isdefined(p))
            continue;

        p thread livesea_center_hud_thread(text);
    }
}


livesea_center_hud_thread(text)
{
    self notify("livesea_center_text");
    self endon("livesea_center_text");
    self endon("disconnect");

    if(isdefined(self.livesea_center_hud))
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
    hud.color = (1,0,1);

    hud setText(text);

    hud fadeOverTime(0.3);
    hud.alpha = 1;

    wait 4;

    hud fadeOverTime(0.8);
    hud.alpha = 0;

    wait 0.8;

    if(isdefined(self.livesea_center_hud))
    {
        hud destroy();
        self.livesea_center_hud = undefined;
    }
}