#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
    level.livesea_rage_active = false;
    level.livesea_rage_endtime = 0;
    level.livesea_next_rage = 0;
}

livesea_trigger_rage()
{
    now = gettime();

    if (now < level.livesea_next_rage)
        return;

    level.livesea_next_rage = now + 300;

    livesea_activate_or_extend_rage(30);
}

livesea_activate_or_extend_rage(seconds)
{
    now = gettime();

    if (level.livesea_rage_active)
    {
        level.livesea_rage_endtime += seconds * 1000;
        return;
    }

    level.livesea_rage_active = true;
    level.livesea_rage_endtime = now + seconds * 1000;

    level.livesea_old_walk = level.zombie_move_speed;
    level.livesea_old_run = level.zombie_run_speed;

    level.zombie_move_speed = 220;
    level.zombie_run_speed = 420;

    if (!isdefined(level.zombie_total))
        level.zombie_total = 0;

    level.zombie_total += 20;

    level thread livesea_force_spawn_wave();

    wait 0.2;

    livesea_kill_existing();

    level thread livesea_rage_enforcer();
    level thread livesea_rage_timer();

    players = getentarray("player","classname");

    foreach(p in players)
    {
        if (!isdefined(p))
            continue;

        p playsound("zmb_laugh_child");
        p thread livesea_rage_hud();
    }
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

livesea_kill_existing()
{
    enemies = getaiarray("axis");

    if (!isdefined(enemies))
        return;

    foreach(z in enemies)
    {
        if (!isdefined(z))
            continue;

        z.health = 0;

        if (isdefined(z))
            z delete();
    }
}

livesea_rage_enforcer()
{
    while(level.livesea_rage_active)
    {
        wait 0.1;

        zombies = getentarray("actor","classname");

        foreach(z in zombies)
        {
            if (!isdefined(z))
                continue;

            if (!isalive(z))
                continue;

            z setmovespeedscale(1.8);
        }
    }
}

livesea_rage_timer()
{
    while(level.livesea_rage_active)
    {
        wait 0.1;

        if (gettime() >= level.livesea_rage_endtime)
        {
            level.livesea_rage_active = false;

            level.zombie_move_speed = level.livesea_old_walk;
            level.zombie_run_speed = level.livesea_old_run;

            livesea_kill_existing();

            return;
        }
    }
}

livesea_rage_hud()
{
    self endon("disconnect");

    if (isdefined(self.livesea_rage_hud))
        return;

    hud = newClientHudElem(self);
    self.livesea_rage_hud = hud;

    hud.horzAlign = "center";
    hud.vertAlign = "bottom";
    hud.alignX = "center";
    hud.alignY = "bottom";

    hud.x = 0;
    hud.y = -80;

    hud.font = "hudbig";
    hud.fontScale = 2.2;

    hud.color = (1,0,0);
    hud.alpha = 1;

    hud.label = &"ZOMBIES ENRAGÉS : ";

    while(level.livesea_rage_active)
    {
        remaining = int((level.livesea_rage_endtime - gettime()) / 1000);

        if (remaining <= 0)
            break;

        hud setTimer(remaining);

        wait 1;
    }

    hud destroy();
    self.livesea_rage_hud = undefined;
}