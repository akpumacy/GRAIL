import xrpl
import os, json
from xrpl.wallet import Wallet

testnet_url = "https://s.altnet.rippletest.net:51234"
client = xrpl.clients.JsonRpcClient(testnet_url)

#-------- load cold wallet
if os.path.exists("cold_address.json"):
    with open('cold_address.json', 'r') as openfile:
        json_object = json.load(openfile)
cold_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

#-------- load hot wallet
receiver_account = "account_1.json"
if os.path.exists(receiver_account):
    with open(receiver_account, 'r') as openfile:
        json_object = json.load(openfile)
hot_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

#-------- Send token
currency_code = "RED"
issue_quantity = "125"
send_token_tx = xrpl.models.transactions.Payment(
    account=cold_wallet.classic_address,
    destination=hot_wallet.classic_address,
    amount=xrpl.models.amounts.issued_currency_amount.IssuedCurrencyAmount(
        currency=currency_code,
        issuer=cold_wallet.classic_address,
        value=issue_quantity
    )
)
pay_prepared = xrpl.transaction.safe_sign_and_autofill_transaction(
    transaction=send_token_tx,
    wallet=cold_wallet,
    client=client,
)
print(f"Sending {issue_quantity} {currency_code} to {hot_wallet.classic_address}...")
response = xrpl.transaction.send_reliable_submission(pay_prepared, client)
print(response)