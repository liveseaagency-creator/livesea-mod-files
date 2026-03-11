#include maps\mp\_utility;
#include common_scripts\utility;

livesea_remove_current_weapon()
{
    players = getentarray("player","classname");

    foreach(p in players)
    {
        if(!isdefined(p))
            continue;

        weap = p getCurrentWeapon();

        if(!isdefined(weap))
            continue;

        p takeWeapon(weap);

        p thread livesea_center_hud_thread("^1ARME SUPPRIMÉE");
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
    hud.color = (1,0,0);

    hud setText(text);

    hud fadeOverTime(0.3);
    hud.alpha = 1;

    wait 3;

    hud fadeOverTime(0.8);
    hud.alpha = 0;

    wait 0.8;

    if(isdefined(self.livesea_center_hud))
    {
        hud destroy();
        self.livesea_center_hud = undefined;
    }
}