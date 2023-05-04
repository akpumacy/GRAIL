import xrpl
from xrpl.wallet import generate_faucet_wallet
import json

acount_name = "cold_address"

testnet_url = "https://s.altnet.rippletest.net:51234"
client = xrpl.clients.JsonRpcClient(testnet_url)

#-------- create wallet
faucet_url = "https://faucet.altnet.rippletest.net/accounts"
print("Getting a new account from the Testnet faucet...")
test_wallet = generate_faucet_wallet(client, debug=True)

#-------- dump details to json file
print("#### Description of Wallet:")

dictionary = {
    "seed": test_wallet.seed,
    "sequence": test_wallet.sequence,
    "classic address": test_wallet.classic_address,
    "private key": test_wallet.private_key,
    "public key": test_wallet.public_key
}
print(dictionary)
 
json_object = json.dumps(dictionary, indent=4)
 
with open(f"{acount_name}.json", "w") as outfile:
    outfile.write(json_object)
