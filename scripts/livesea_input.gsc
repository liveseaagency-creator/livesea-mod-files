#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
    if (isdefined(level.livesea_input_started) && level.livesea_input_started)
        return;

    level.livesea_input_started = true;

    SetDvar("livesea_mod_alt", 0);
    SetDvar("livesea_mod_f6", 0);
    SetDvar("livesea_mod_f7", 0);

    SetDvar("livesea_trig_bonus1000", 0);
    SetDvar("livesea_trig_minus1000", 0);
	SetDvar("livesea_trig_plus15", 0);
    SetDvar("livesea_trig_followbonus", 0);
    SetDvar("livesea_trig_resetpoints", 0);
    SetDvar("livesea_trig_allperks", 0);
    SetDvar("livesea_trig_removeperks", 0);
    SetDvar("livesea_trig_restartmap", 0);
    SetDvar("livesea_trig_add10zombies", 0);
    SetDvar("livesea_trig_add50zombies", 0);
    SetDvar("livesea_trig_roundup", 0);
    SetDvar("livesea_trig_rounddown", 0);
    SetDvar("livesea_trig_removeweapon", 0);

    SetDvar("livesea_trig_nuke", 0);
    SetDvar("livesea_trig_doublepoints", 0);
    SetDvar("livesea_trig_instakill", 0);
    SetDvar("livesea_trig_fullammo", 0);
    SetDvar("livesea_trig_carpenter", 0);
    SetDvar("livesea_trig_firesale", 0);
    SetDvar("livesea_trig_randompower", 0);
    SetDvar("livesea_trig_x5", 0);
    SetDvar("livesea_trig_rage", 0);
    SetDvar("livesea_trig_invincible", 0);

    SetDvar("livesea_trig_unlimitedammo", 0);

    level.livesea_alt_time = 0;
    level.livesea_f6_time = 0;
    level.livesea_f7_time = 0;
    level.livesea_global_next = 0;

    level thread livesea_input_listener();
}

livesea_input_listener()
{
    for (;;)
    {
        wait 0.03;

        now = gettime();

        if (GetDvarInt("livesea_mod_alt") == 1)
        {
            level.livesea_alt_time = now;
            SetDvar("livesea_mod_alt", 0);
        }

        if (GetDvarInt("livesea_mod_f6") == 1)
        {
            level.livesea_f6_time = now;
            SetDvar("livesea_mod_f6", 0);
        }

        if (GetDvarInt("livesea_mod_f7") == 1)
        {
            level.livesea_f7_time = now;
            SetDvar("livesea_mod_f7", 0);
        }

        alt_active = (now - level.livesea_alt_time <= 250);
        f6_active  = (now - level.livesea_f6_time <= 300);
        f7_active  = (now - level.livesea_f7_time <= 300);

        if (f6_active || f7_active)
            alt_active = false;

        if (now < level.livesea_global_next)
        {
            livesea_purge_invalid_triggers(alt_active, f6_active, f7_active);
            continue;
        }

        if (f7_active)
        {
            if (GetDvarInt("livesea_trig_unlimitedammo"))
            {
                SetDvar("livesea_trig_unlimitedammo", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_unlimited_ammo::livesea_trigger_unlimited_ammo();
                continue;
            }

			if (GetDvarInt("livesea_trig_plus15"))
			{
			    SetDvar("livesea_trig_plus15", 0);
			    level.livesea_global_next = now + 200;
			    level thread scripts\livesea_points_bonus::livesea_trigger_bonus_points(15);
			    continue;
			}

			if (GetDvarInt("livesea_trig_followbonus"))
			{
			    SetDvar("livesea_trig_followbonus", 0);
			    level.livesea_global_next = now + 200;
			    level thread scripts\livesea_points_bonus::livesea_follow_bonus();
			    continue;
			}

			if (GetDvarInt("livesea_trig_resetpoints"))
			{
			    SetDvar("livesea_trig_resetpoints", 0);
			    level.livesea_global_next = now + 200;
			    level thread scripts\livesea_points_bonus::livesea_reset_points();
			    continue;
			}
        }

        if (f6_active)
        {
            if (GetDvarInt("livesea_trig_x5"))
            {
                SetDvar("livesea_trig_x5", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_multiplier_x5::livesea_trigger_x5();
                continue;
            }

            if (GetDvarInt("livesea_trig_nuke"))
            {
                SetDvar("livesea_trig_nuke", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("nuke");
                continue;
            }

            if (GetDvarInt("livesea_trig_doublepoints"))
            {
                SetDvar("livesea_trig_doublepoints", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("double_points");
                continue;
            }

            if (GetDvarInt("livesea_trig_instakill"))
            {
                SetDvar("livesea_trig_instakill", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("insta_kill");
                continue;
            }

            if (GetDvarInt("livesea_trig_fullammo"))
            {
                SetDvar("livesea_trig_fullammo", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("full_ammo");
                continue;
            }

            if (GetDvarInt("livesea_trig_carpenter"))
            {
                SetDvar("livesea_trig_carpenter", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("carpenter");
                continue;
            }

            if (GetDvarInt("livesea_trig_firesale"))
            {
                SetDvar("livesea_trig_firesale", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_powerup_all("fire_sale");
                continue;
            }

            if (GetDvarInt("livesea_trig_randompower"))
            {
                SetDvar("livesea_trig_randompower", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_powerups::livesea_spawn_random_powerup();
                continue;
            }

            if (GetDvarInt("livesea_trig_rage"))
            {
                SetDvar("livesea_trig_rage", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_rage_zombies::livesea_trigger_rage();
                continue;
            }

            if (GetDvarInt("livesea_trig_invincible"))
            {
                SetDvar("livesea_trig_invincible", 0);
                level.livesea_global_next = now + 200;
                level thread scripts\livesea_invincible::livesea_trigger_invincible();
                continue;
            }
        }

        if (!alt_active)
        {
            livesea_purge_invalid_triggers(alt_active, f6_active, f7_active);
            continue;
        }

        if (GetDvarInt("livesea_trig_restartmap"))
        {
            SetDvar("livesea_trig_restartmap", 0);
            level thread scripts\livesea_restart::livesea_restart_map();
            continue;
        }

        if (GetDvarInt("livesea_trig_bonus1000"))
        {
            SetDvar("livesea_trig_bonus1000", 0);
            level thread scripts\livesea_points_bonus::livesea_trigger_bonus_points(1000);
            continue;
        }

        if (GetDvarInt("livesea_trig_minus1000"))
        {
            SetDvar("livesea_trig_minus1000", 0);
            level thread scripts\livesea_points_bonus::livesea_trigger_bonus_points(-1000);
            continue;
        }

        if (GetDvarInt("livesea_trig_allperks"))
        {
            SetDvar("livesea_trig_allperks", 0);
            level thread scripts\livesea_perks::livesea_give_all_map_perks();
            continue;
        }

        if (GetDvarInt("livesea_trig_removeperks"))
        {
            SetDvar("livesea_trig_removeperks", 0);
            level thread scripts\livesea_perks::livesea_remove_all_perks();
            continue;
        }

        if (GetDvarInt("livesea_trig_add10zombies"))
        {
            SetDvar("livesea_trig_add10zombies", 0);
            level thread scripts\livesea_zombies::livesea_add_zombies(10);
            continue;
        }

        if (GetDvarInt("livesea_trig_add50zombies"))
        {
            SetDvar("livesea_trig_add50zombies", 0);
            level thread scripts\livesea_zombies::livesea_add_zombies(50);
            continue;
        }

        if (GetDvarInt("livesea_trig_roundup"))
        {
            SetDvar("livesea_trig_roundup", 0);
            level thread scripts\livesea_rounds::livesea_round_up();
            continue;
        }

        if (GetDvarInt("livesea_trig_rounddown"))
        {
            SetDvar("livesea_trig_rounddown", 0);
            level thread scripts\livesea_rounds::livesea_round_down();
            continue;
        }

        if (GetDvarInt("livesea_trig_removeweapon"))
        {
            SetDvar("livesea_trig_removeweapon", 0);
            level thread scripts\livesea_remove_weapon::livesea_remove_current_weapon();
            continue;
        }
    }
}

livesea_purge_invalid_triggers(alt_active, f6_active, f7_active)
{
    if (!alt_active)
    {
        SetDvar("livesea_trig_bonus1000", 0);
        SetDvar("livesea_trig_minus1000", 0);
        SetDvar("livesea_trig_allperks", 0);
        SetDvar("livesea_trig_removeperks", 0);
        SetDvar("livesea_trig_restartmap", 0);
        SetDvar("livesea_trig_add10zombies", 0);
        SetDvar("livesea_trig_add50zombies", 0);
        SetDvar("livesea_trig_roundup", 0);
        SetDvar("livesea_trig_rounddown", 0);
        SetDvar("livesea_trig_removeweapon", 0);
    }

    if (!f6_active)
    {
        SetDvar("livesea_trig_x5", 0);
        SetDvar("livesea_trig_nuke", 0);
        SetDvar("livesea_trig_doublepoints", 0);
        SetDvar("livesea_trig_instakill", 0);
        SetDvar("livesea_trig_fullammo", 0);
        SetDvar("livesea_trig_carpenter", 0);
        SetDvar("livesea_trig_firesale", 0);
        SetDvar("livesea_trig_randompower", 0);
        SetDvar("livesea_trig_rage", 0);
        SetDvar("livesea_trig_invincible", 0);
    }

    if (!f7_active)
    {
        SetDvar("livesea_trig_unlimitedammo", 0);
		SetDvar("livesea_trig_plus15", 0);
    	SetDvar("livesea_trig_followbonus", 0);
    	SetDvar("livesea_trig_resetpoints", 0);
    }
}