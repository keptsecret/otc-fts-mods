/*
 * Q4
 * Added calls to delete object if player created with new
 * The item gotten through CreateItem is assumed to be handled by other internal game states
 * Would prefer to use smart pointers to handle this
 */
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    bool createdNewPlayer = false;
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        if (createdNewPlayer) {
            delete player;
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    if (createdNewPlayer) {
        delete player;
    }
}