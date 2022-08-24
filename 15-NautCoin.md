# Naut Coin

In this challenge the code limits the use of the transfer function, however makes no limitations on the transferFrom function that is defined in the inherited contract, erc721.

First we check `balanceOf` to display current balance.
Then call the `approve` function, approving ourselves to use the transferFrom w/ the complete balance.
Then call `transferFrom` passing in the player address, a random address (to receive tokens) and the total balance.