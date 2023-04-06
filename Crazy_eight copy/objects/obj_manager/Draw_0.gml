/// @description Insert description here
// You can write your code in this editor
if (player_win) {
	draw_set_font(fnt_main);
	draw_set_color(c_white);
	draw_text(260, room_height/2 + 200, "Congratulation! You win!");
} else if (enemy_win) {
	draw_set_font(fnt_main);
	draw_set_color(c_white);
	draw_text(20, room_height/2, "Oops! You lost.");
}