## 1. Smart Contracts (SCs)

This module involves development and deploying of smart contracts on Blockchain using Solidity to manage gift cards and coupons. The smart contracts also define security measures to prevent fraudulent transactions by utilizing signatures from multiple parties e.g., customer and retailer. Since each entity participating in this solution requires a Wallet (ethereum), the private keys are used to authorize the transactions on the smart contract. Currently, a separate smart contract exists for management of gift cards and coupons.

### a. SC for Gift Cards

 The smart contract for gift cards is capable of following functionalities:
 
 * Creation of gift cards: When a customer purchases a gift card at the Mall, this transaction takes place on the smart contract where specific information is stored including wallet addresses of customer and mall, purchase and expiry date, amount etc.
 
 * Redemption of gift cards: The gift cards can be redeemed at supported retailers. When a gift card is redeemed, this transaction takes place on the smart contract which also updates the amount available in the gift card. To prevent fraud, signatures from customer and retailer are used to authenticate the transaction.
 
 * Transfer gift-card ownership: This functionality allows customers to transfer the gift cards to one another. 
 
 * Transfer gift-card amount: Apart of transfering a complete gift-card, customers can also transfer partial amounts from one gift-card to another. 
 
 * Manage retail partners of the mall: Since gift cards purchased from a mall are only redeemable through supported retailers, this functionality allows adding/removing partner retailers.
 
 ### b. SC for Coupons
 
 The smart contract for coupons is capable of following functionalities:
 
 * Creation of coupons: Malls/retailers can create coupons based on several use cases including targeted coupons i.e. creating coupons for a specific list of customers or creating coupons for all the customers. The coupons can have a certain redeem limitations as well.
 
 * Redemption of coupons: Similar to gift cards, coupons can also be redeemed at the supported retailers where relevant discount is provided to the customer based on the coupon description including discount type, discount value etc. 
 
 ## 2. Platform Provider API (PP API)
 
PP API is another crucial module in the Redimi solution which communicates data between all the other modules. STRAPI, an opensource Nodejs based Headless Content Management System (CMS) was used to setup a platform for interacting with the smart contracts. PP API serves as a middleware between the blockchain, Mobile Applications, POS Systems and Retailer API (if available). The API allows management of Gift Cards, Coupons, Transactions, Malls/Retailers by serving as the backend-end for the smart contracts. Every change made on the smart contracts is visible on the PP API. Strapi also allows management of data using an integrated front-end. Strapi communicates data to other modules using REST API. 