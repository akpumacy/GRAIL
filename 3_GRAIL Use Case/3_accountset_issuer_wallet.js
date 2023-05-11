const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")
const issuer_wallet = process.env.ISSUER_WALLET

async function main() {
  await client.connect()

  console.log({message:"client connected"})

  const Issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet) // Test secret; don't use for real
  console.log(Issuer_wallet.address)

  // Configure issuer (cold address) settings ----------------------------------
  const cold_settings_tx = {
  "TransactionType": "AccountSet",
  "Account": Issuer_wallet.address,
  "TransferRate": 0,
  "TickSize": 3,
  "Domain": "https://redimi.net", // "example.com"
  "SetFlag": xrpl.AccountSetAsfFlags.asfDefaultRipple,
    
  // Using tf flags, we can enable more flags in one transaction
  "Flags": (xrpl.AccountSetTfFlags.tfDisallowXRP |
           xrpl.AccountSetTfFlags.tfRequireDestTag)
  }

  const cst_prepared = await client.autofill(cold_settings_tx)
  const cst_signed = Issuer_wallet.sign(cst_prepared)
  console.log("Sending cold address AccountSet transaction...")
  
  const cst_result = await client.submitAndWait(cst_signed.tx_blob)
  
  if (cst_result.result.meta.TransactionResult == "tesSUCCESS") {
    console.log(`Transaction succeeded: https://testnet.xrpl.org/transactions/${cst_signed.hash}`)
  } else {
    throw `Error sending transaction: ${cst_result}`
  }

  client.disconnect()
}
  
main()
