const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")

const dotenv = require('dotenv')
dotenv.config({ path: `H:/Pumacy/Programs/redimi/XRP/GRAIL/3_GRAIL Use Case/.env`, override: true });

const issuer_wallet_seed = process.env.ISSUER_WALLET_SEED

async function main() {
    try{
        await client.connect()

        console.log("client connected")

        //----- load issuer wallet
        const issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet_seed) // Test secret; don't use for real
        console.log(`Issuer Wallet Address: ${issuer_wallet.address}`)
        const my_balance = await client.getXrpBalance(issuer_wallet.address)
        console.log(`Issuer Wallet XRP Balance: ${my_balance}`);

        //----- Configure issuer address settings ---------------------------------
        const issuer_settings_tx = {
            "TransactionType": "AccountSet",
            "Account": issuer_wallet.address,
            "TransferRate": 0,
            "TickSize": 3,
            "Domain": "6578616D706C652E636F6D", // "example.com"
            "SetFlag": xrpl.AccountSetAsfFlags.asfDefaultRipple
            // // Using tf flags, we can enable more flags in one transaction
            // "Flags": (xrpl.AccountSetTfFlags.tfDisallowXRP |
            //          xrpl.AccountSetTfFlags.tfRequireDestTag)
          }

        const hst_prepared = await client.autofill(issuer_settings_tx)
        const hst_signed = issuer_wallet.sign(hst_prepared)
        console.log("Sending issuer address AccountSet transaction...")

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