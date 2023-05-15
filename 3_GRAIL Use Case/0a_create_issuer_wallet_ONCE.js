const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")

const dotenv = require('dotenv')
dotenv.config({ path: `H:/Pumacy/Programs/redimi/XRP/GRAIL/3_GRAIL Use Case/.env`, override: true });

const issuer_wallet_seed = process.env.ISSUER_WALLET_SEED

async function main() {
    try{
        await client.connect()

        console.log("client connected")

        //----- create test wallet ---------------------------------
        const issuer_wallet = xrpl.Wallet.generate()
        console.log(issuer_wallet)

        //----- Create a wallet and fund it with the Testnet faucet:  ---------------------------------
        const fund_result = await client.fundWallet()
        const faucet_wallet = fund_result.wallet
        console.log(`Faucet Wallet Address: ${faucet_wallet.address}`)
        const faucet_balance = await client.getXrpBalance(faucet_wallet.address)
        console.log(`Faucet Wallet XRP Balance: ${faucet_balance}`);

        //----- prepare XRP transfer transaction ---------------------------------
        console.log("\nMust fund XRP to issuer wallet...")
        const prepared = await client.autofill({
            "TransactionType": "Payment",
            "Account": faucet_wallet.address,
            "Amount": xrpl.xrpToDrops("1000"), //minimum required
            "Destination": issuer_wallet.address
        })
        const max_ledger = prepared.LastLedgerSequence
        console.log("Prepared transaction instructions:", prepared)
        console.log("Transaction cost:", xrpl.dropsToXrp(prepared.Fee), "XRP")
        console.log("Transaction expires after ledger:", max_ledger)

        //----- sign prepared instructions ---------------------------------
        const signed = faucet_wallet.sign(prepared)
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

        const my_balance = await client.getXrpBalance(issuer_wallet.address)
        console.log(`Issuer Wallet XRP Balance: ${my_balance}`);

    } catch (error) {
        console.log(error)
        }
}

main()