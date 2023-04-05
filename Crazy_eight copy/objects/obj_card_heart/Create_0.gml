/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

suit = "hearts";
num = instance_number(obj_card_heart);

img_name = "_" + string(num) + "_of_" + suit;
sprite_index = asset_get_index(img_name);