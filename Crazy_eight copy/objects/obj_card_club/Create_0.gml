/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

suit = "clubs";
num = instance_number(obj_card_club);

img_name = "_" + string(num) + "_of_" + suit;
sprite_index = asset_get_index(img_name);