#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

init()
{
    level.livesea_x5_active = 0;
    level.livesea_x5_endtime = 0;
    level.livesea_next_x5 = 0;
}

livesea_trigger_x5()
{
    now = gettime();

    if (now < level.livesea_next_x5)
        return;

    level.livesea_next_x5 = now + 250;

    livesea_activate_or_extend_x5(30);
    livesea_x5_feedback_all();
}

livesea_activate_or_extend_x5(seconds)
{
    now = gettime();

    if (level.livesea_x5_active)
    {
        level.livesea_x5_endtime += (seconds * 1000);
        return;
    }

    level.livesea_x5_active = 1;
    level.livesea_x5_endtime = now + (seconds * 1000);

    players = getentarray("player", "classname");

    foreach (p in players)
    {
        if (!isdefined(p))
            continue;

        if (!isplayer(p))
            continue;

        if (!isdefined(p.livesea_x5_monitor_started))
        {
            p.livesea_x5_monitor_started = 1;
            p thread livesea_x5_score_monitor();
        }

        if (!isdefined(p.livesea_x5_hud_started))
        {
            p.livesea_x5_hud_started = 1;
            p thread livesea_x5_timer_hud();
        }
    }
}

livesea_x5_feedback_all()
{
    players = getentarray("player", "classname");

    foreach (p in players)
    {
        if (!isdefined(p))
            continue;

        if (!isplayer(p))
            continue;

        p iprintln("^6MULTIPLICATEUR X5 ACTIVE !");
        p playsound("zmb_powerup_grabbed");
    }
}

livesea_x5_score_monitor()
{
    self endon("disconnect");

    if (!isdefined(self.score))
        self.score = 0;

    self.livesea_x5_last_score = self.score;
    self.livesea_x5_internal_add = 0;

    for (;;)
    {
        wait 0.05;

        if (!level.livesea_x5_active)
        {
            self.livesea_x5_last_score = self.score;
            continue;
        }

        if (gettime() >= level.livesea_x5_endtime)
        {
            level.livesea_x5_active = 0;
            self.livesea_x5_last_score = self.score;
            continue;
        }

        if (isdefined(level.livesea_dp_endtime) && gettime() < level.livesea_dp_endtime)
        {
            self.livesea_x5_last_score = self.score;
            continue;
        }

        if (self.livesea_x5_internal_add)
        {
            self.livesea_x5_last_score = self.score;
            continue;
        }

        cur = self.score;
        last = self.livesea_x5_last_score;

        if (cur > last)
        {
            delta = cur - last;

            if (delta > 300)
            {
                self.livesea_x5_last_score = cur;
                continue;
            }

            bonus = delta * 4;

            self.livesea_x5_internal_add = 1;
            self.score += bonus;
            self.livesea_x5_internal_add = 0;

            self.livesea_x5_last_score = self.score;
        }
        else
        {
            self.livesea_x5_last_score = cur;
        }
    }
}

livesea_x5_timer_hud()
{
    self endon("disconnect");

    if (isdefined(self.livesea_x5_hud))
        return;

    hud = newClientHudElem(self);
    self.livesea_x5_hud = hud;

    hud.horzAlign = "center";
    hud.vertAlign = "top";
    hud.alignX = "center";
    hud.alignY = "top";

    hud.x = 0;
    hud.y = 58;

    hud.font = "hudbig";
    hud.fontScale = 2.4;

    hud.color = (1,0.6,0);
    hud.alpha = 1;

    hud.sort = 999999;

    hud.label = &"MULTIPLICATEUR X5 : ";

    while(level.livesea_x5_active)
    {
        remaining = int((level.livesea_x5_endtime - gettime()) / 1000);

        if (remaining <= 0)
            break;

        hud setTimer(remaining);

        wait 1;
    }

    hud destroy();

    self.livesea_x5_hud = undefined;
    self.livesea_x5_hud_started = undefined;
}