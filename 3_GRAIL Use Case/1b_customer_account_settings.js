const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")

const dotenv = require('dotenv')
dotenv.config({ path: `H:/Pumacy/Programs/redimi/XRP/GRAIL/3_GRAIL Use Case/.env`, override: true });

const customer_wallet_seed = "sEdS1kJ7iMwzFNrhU3UVsDJSzqEr5iz"

async function main() {
    try{
        await client.connect()

        console.log("client connected")

        //----- load customer wallet
        const customer_wallet = xrpl.Wallet.fromSeed(customer_wallet_seed) // Test secret; don't use for real
        console.log(`customer Wallet Address: ${customer_wallet.address}`)
        const my_balance = await client.getXrpBalance(customer_wallet.address)
        console.log(`customer Wallet XRP Balance: ${my_balance}`);

        //----- Configure customer address settings ---------------------------------
        const customer_settings_tx = {
            "TransactionType": "AccountSet",
            "Account": customer_wallet.address,
            "TransferRate": 0,
            "TickSize": 3,
            "Domain": "6578616D706C652E636F6D", // "example.com"
            "SetFlag": xrpl.AccountSetAsfFlags.asfDefaultRipple,
            "Flags": (xrpl.AccountSetTfFlags.tfRequireDestTag)
          }

        const hst_prepared = await client.autofill(customer_settings_tx)
        const hst_signed = customer_wallet.sign(hst_prepared)
        console.log("Sending customer address AccountSet transaction...")

        hst_result = await client.submitAndWait(hst_signed.tx_blob)
        if (hst_result.result.meta.TransactionResult == "tesSUCCESS") {
            console.log(`Transaction succeeded: https://testnet.xrpl.org/transactions/${hst_signed.hash}`)
        } else {
            throw `Error sending transaction: ${hst_result.result.meta.TransactionResult}`
        }

        console.log("Success.")

    } catch (error) {
        console.log(error)
        }
}

main()