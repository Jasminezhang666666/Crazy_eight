if (back) {
	sprite_index = card_back;
} else {
	sprite_index = asset_get_index("_" + string(num) + "_of_" + suit);
}