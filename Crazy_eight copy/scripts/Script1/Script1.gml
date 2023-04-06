// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

globalvar card_pile;
card_pile = ds_list_create();
globalvar card_discard_pile;
card_discard_pile = ds_list_create();

globalvar hand_enemy;
hand_enemy = ds_list_create();
globalvar hand_player;
hand_player = ds_list_create();

globalvar phase_shuffle;
phase_shuffle = true;
globalvar phase_deal;
phase_deal = false;
globalvar phase_firstcard;
phase_firstcard = false;
globalvar phase_check_card;
phase_check_card = false;
globalvar phase_decision;
phase_decision = false;
globalvar phase_put_decision;
phase_put_decision = false;
globalvar phase_enemy_turn;
phase_enemy_turn = false;
globalvar phase_check_card_enemy;
phase_check_card_enemy = false;