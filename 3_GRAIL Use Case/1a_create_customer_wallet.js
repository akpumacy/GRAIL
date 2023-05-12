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

        //----- create test wallet ---------------------------------
        const customer_wallet = xrpl.Wallet.generate()
        console.log(customer_wallet)

        //----- prepare XRP transfer transaction ---------------------------------
        console.log("\nMust tranfer XRP to customer wallet to activate...")
        const prepared = await client.autofill({
            "TransactionType": "Payment",
            "Account": issuer_wallet.address,
            "Amount": xrpl.xrpToDrops("20"), //minimum required
            "Destination": customer_wallet.address
        })
        const max_ledger = prepared.LastLedgerSequence
        console.log("Prepared transaction instructions:", prepared)
        console.log("Transaction cost:", xrpl.dropsToXrp(prepared.Fee), "XRP")
        console.log("Transaction expires after ledger:", max_ledger)

        //----- sign prepared instructions ---------------------------------
        const signed = issuer_wallet.sign(prepared)
        // console.log("Identifying hash:", signed.hash)
        // console.log("Signed blob:", signed.tx_blob)

        //----- submit signed blob ---------------------------------
        console.log("Sending XRP Transfer transaction...")

        const hst_result = await client.submitAndWait(signed.tx_blob)
        if (hst_result.result.meta.TransactionResult == "tesSUCCESS") {
            console.log(`Transaction succeeded: https://testnet.xrpl.org/transactions/${signed.hash}`)
        } 
        else if (hst_result.result.meta.TransactionResult == "tecUNFUNDED_PAYMENT"){
            throw `Issuer wallet does not have enough funds.`
        }
        else {
            throw `Error sending transaction: ${hst_result.result.meta.TransactionResult}`
        }

        //----- check transaction results ---------------------------------
        console.log("Balance changes:", JSON.stringify(xrpl.getBalanceChanges(hst_result.result.meta), null, 2))

        const account_info = await client.request({
            command: "account_info",
            account: customer_wallet.address
            });
        console.log(account_info)

    } catch (error) {
        console.log(error)
        }
}

main()