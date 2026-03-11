#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
    level.livesea_busy = false;
    level.livesea_prev_from = -1;

    level.livesea_round_pending = 0;

    level thread livesea_round_pending_controller();
}


livesea_round_pending_controller()
{
    for(;;)
    {
        wait 0.1;

        if(level.livesea_round_pending == 0)
            continue;

        enemies = getaiarray("axis");

        if(!isdefined(enemies) || enemies.size == 0)
            continue;

        amount = level.livesea_round_pending;
        level.livesea_round_pending = 0;

        current = level.round_number;

        if(amount > 0)
        {
            level.round_number = current + amount - 1;
            level thread livesea_change("next");
        }
else
{
    target = current + amount;

    if(target < 1)
        target = 1;

    level.round_number = target + 1;

    level thread livesea_change("prev");
}
    }
}


livesea_round_up()
{
    enemies = getaiarray("axis");

    if(!isdefined(enemies) || enemies.size == 0)
    {
        level.livesea_round_pending++;

        livesea_center_message("^2+" + level.livesea_round_pending + " MANCHE (EN ATTENTE)");
        return;
    }

    livesea_center_message("^2+1 MANCHE");
    level thread livesea_change("next");
}


livesea_round_down()
{
    enemies = getaiarray("axis");

    if(!isdefined(enemies) || enemies.size == 0)
    {
        level.livesea_round_pending--;

        livesea_center_message("^1" + level.livesea_round_pending + " MANCHE (EN ATTENTE)");
        return;
    }

    livesea_center_message("^1-1 MANCHE");
    level thread livesea_change("prev");
}


livesea_change(mode)
{
    if (!isdefined(level.livesea_busy))
        level.livesea_busy = false;

    if (level.livesea_busy)
        return;

    if (!isdefined(level.round_number))
        return;

    level.livesea_busy = true;

    current = level.round_number;

    if (mode == "next")
    {
        livesea_kill_all_clean();
        level.livesea_busy = false;
        return;
    }

    if (mode == "prev")
    {
        level.livesea_prev_from = current;

        if (current <= 2)
            target = 0;
        else
            target = current - 2;

        if (target < 0)
            target = 0;

        level.round_number = target;

        if (isdefined(level.rounds_played))
            level.rounds_played = target;

        if (isdefined(level.rounds_completed))
            level.rounds_completed = target - 1;

        livesea_force_wipe_no_increment();

        wait 0.2;

        level notify("round_transition");
        wait 0.1;

        level notify("round_start");
        level notify("update_round_hud");
    }

    level.livesea_busy = false;
}


livesea_kill_all_clean()
{
    level.zombie_total = 0;

    passes = 0;

    while (passes < 20)
    {
        enemy = livesea_get_enemies();

        foreach (z in enemy)
        {
            if (!isdefined(z))
                continue;

            z.health = 0;

            if (isdefined(z))
                z delete();
        }

        wait 0.05;
        passes++;
    }
}


livesea_force_wipe_no_increment()
{
    passes = 0;

    while (passes < 20)
    {
        enemy = livesea_get_enemies();

        foreach (z in enemy)
        {
            if (!isdefined(z))
                continue;

            z delete();
        }

        wait 0.05;
        passes++;
    }

    level.zombie_total = 0;
}


livesea_get_enemies()
{
    ai = getaiarray("axis");

    if (!isdefined(ai))
        return [];

    list = [];

    foreach(e in ai)
    {
        if (!isdefined(e))
            continue;

        if (!isdefined(e.health))
            continue;

        list[list.size] = e;
    }

    return list;
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