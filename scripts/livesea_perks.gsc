#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_perks;

init()
{
    level thread livesea_on_connect();
}

livesea_on_connect()
{
    for(;;)
    {
        level waittill("connecting", player);
        player thread livesea_remove_perk_limit();
    }
}

livesea_remove_perk_limit()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");

        self.num_perks = -5;
    }
}

livesea_give_all_map_perks()
{
    players = getentarray("player", "classname");
    foreach (p in players)
    {
        if (!isdefined(p) || !isplayer(p))
            continue;
        p thread livesea_give_all_perks_single();
    }
}

livesea_give_all_perks_single()
{
    self endon("disconnect");
    self endon("death");

    if (!isdefined(self.is_drinking))
        self.is_drinking = false;

    if (self.is_drinking)
        return;

    self.is_drinking = true;

    savedweapon = self getcurrentweapon();
    self playsound("evt_bottle_dispense");

    gun = self maps\mp\zombies\_zm_perks::perk_give_bottle_begin("specialty_armorvest");

    evt = self waittill_any_return(
        "fake_death",
        "death",
        "player_downed",
        "weapon_change_complete"
    );

    if (evt != "weapon_change_complete")
    {
        self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, "specialty_armorvest");
        self.is_drinking = false;
        return;
    }

    if (!self hasperk("specialty_armorvest"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_quickrevive"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_quickrevive", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_fastreload"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_fastreload", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_rof"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_longersprint"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_longersprint", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_additionalprimaryweapon"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_additionalprimaryweapon", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_deadshot"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_deadshot", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_tombstone"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_tombstone", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_electriccherry"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_electriccherry", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_vultureaid"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_vultureaid", 1);
        wait 0.05;
    }

    if (!self hasperk("specialty_flakjacket"))
    {
        maps\mp\zombies\_zm_perks::wait_give_perk("specialty_flakjacket", 1);
        wait 0.05;
    }

    self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, "specialty_armorvest");

    self thread livesea_center_hud_thread("^6TOUS LES ATOUTS ACTIVÉS !");

    self switchtoweapon(savedweapon);

    self.is_drinking = false;
}

livesea_remove_all_perks()
{
    players = getentarray("player", "classname");

    foreach (p in players)
    {
        if (!isdefined(p) || !isplayer(p))
            continue;

        p thread livesea_remove_all_perks_single();
    }
}

livesea_remove_all_perks_single()
{
    self notify("specialty_armorvest_stop");
    self notify("specialty_quickrevive_stop");
    self notify("specialty_fastreload_stop");
    self notify("specialty_rof_stop");
    self notify("specialty_longersprint_stop");
    self notify("specialty_additionalprimaryweapon_stop");
    self notify("specialty_deadshot_stop");
    self notify("specialty_tombstone_stop");
    self notify("specialty_electriccherry_stop");
    self notify("specialty_vultureaid_stop");
    self notify("specialty_flakjacket_stop");

    self thread livesea_center_hud_thread("^1TOUS LES ATOUTS RETIRÉS !");
}

livesea_center_hud_thread(text)
{
    self endon("disconnect");

    hud = newclienthudelem(self);

    hud.horzAlign = "center";
    hud.vertAlign = "middle";
    hud.alignX = "center";
    hud.alignY = "middle";

    hud.x = 0;
    hud.y = -40;

    hud.fontScale = 2.6;
    hud.color = (1,0,1);

    hud.alpha = 0;

    hud setText(text);

    hud fadeOverTime(0.3);
    hud.alpha = 1;

    wait 5;

    hud fadeOverTime(0.8);
    hud.alpha = 0;

    wait 0.8;

    hud destroy();
}