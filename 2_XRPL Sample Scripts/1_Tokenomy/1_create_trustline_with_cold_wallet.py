import xrpl
import os, json
from xrpl.wallet import Wallet

testnet_url = "https://s.altnet.rippletest.net:51234"
client = xrpl.clients.JsonRpcClient(testnet_url)

#-------- Configure issuer (cold address) settings
if os.path.exists("cold_address.json"):
    with open('cold_address.json', 'r') as openfile:
        json_object = json.load(openfile)
cold_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

cold_settings_tx = xrpl.models.transactions.AccountSet(
    account=cold_wallet.classic_address,
    transfer_rate=0,
    tick_size=5,
    domain=bytes.hex("example.com".encode("ASCII")),
    set_flag=xrpl.models.transactions.AccountSetFlag.ASF_DEFAULT_RIPPLE,
)
cst_prepared = xrpl.transaction.safe_sign_and_autofill_transaction(
    transaction=cold_settings_tx,
    wallet=cold_wallet,
    client=client,
)
print("Sending cold address AccountSet transaction...")
response = xrpl.transaction.send_reliable_submission(cst_prepared, client)
# print(response)

#-------- Configure hot address settings and setup trust line
accounts = [i for i in os.listdir() if "account" in i and ".json" in i]

for account in accounts:
    if os.path.exists(account):
        with open(account, 'r') as openfile:
            json_object = json.load(openfile)
    hot_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

    print(f"Current Address: {hot_wallet.classic_address}")

    hot_settings_tx = xrpl.models.transactions.AccountSet(
        account=hot_wallet.classic_address,
        set_flag=xrpl.models.transactions.AccountSetFlag.ASF_REQUIRE_AUTH,
    )
    hst_prepared = xrpl.transaction.safe_sign_and_autofill_transaction(
        transaction=hot_settings_tx,
        wallet=hot_wallet,
        client=client,
    )
    print("Sending hot address AccountSet transaction...")
    response = xrpl.transaction.send_reliable_submission(hst_prepared, client)
    print(response)

    # Create trust line from hot to cold address -----------------------------------
    currency_code = "RED"
    trust_set_tx = xrpl.models.transactions.TrustSet(
        account=hot_wallet.classic_address,
        limit_amount=xrpl.models.amounts.issued_currency_amount.IssuedCurrencyAmount(
            currency=currency_code,
            issuer=cold_wallet.classic_address,
            value="10000000000", # Large limit, arbitrarily chosen
        )
    )
    ts_prepared = xrpl.transaction.safe_sign_and_autofill_transaction(
        transaction=trust_set_tx,
        wallet=hot_wallet,
        client=client,
    )
    print("Creating trust line from hot address to issuer...") 
    response = xrpl.transaction.send_reliable_submission(ts_prepared, client)
    print(response)