# GRAIL Implementation/ Existing Architecture

Redimi solution comprises of several modules where each module accomplishes a crucial task. Following is the list of these modules:

For the purpose of demonstration, the gift cards can behave as a fungible tokens since they are partially redeemable and transferable. Therefore, a token can be created as shown in [Tokenomy](/XRP%20Scripts/1_Tokenomy/). For transfering of tokens, we have setup multiple wallets including a cold wallet. We have also added token transfer functionality to already available wallet management application as shown in [Wallet Management](/XRP%20Scripts/2_Account_Management/). This allows wallets to transfer tokens directly from the app.

Following sections describe further our existing solution and its sub-modules:

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

## 3. Mobile Applications

Currently, there are two types of mobile solutions available, one for the customers and another for the retailers. 

The mobile application for customers, also known as Mobile Wallet allows customers to register/login and manage their existing gift cards, coupons and transactions. Furthermore, customers can also import and store 3rd party gift cards by scanning their QR/Barcodes. To improve user experience, customers can store wallet addresses as contacts, making it easier to select a contact when transfering gift cards. When redeeming, customers can also choose the amount they wish to redeem from the gift card. A QR code is created with encrypted information regarding the gift card. This information also includes signature from the customer's wallet.

Another mobile application (Redeem Wallet App) was developed for the cashiers at retail stores to provide an easy and independent redeeming solution that does not require any manipulation of the POS System. The Redeem Wallet App allows cashiers to sign in and scan customer gift card QR codes using the phone's camera. As soon as the QR is scanned, the cashier can process and transaction. In response, the cashier receives the amount that was successfully redeemed from the customer's gift card. If any amount remains to be paid, customer can pay it using other resources and/or another gift card.

### 4. Purchase Portal

To allow customers to purchase gift cards with easy and comfort, a purchase portal is setup on the Redimi's website where customers can choose a mall and amount of gift card they wish to purchase. Multiple payment methods are integrated at checkout for the ease of the customer.

## 5. Payment Settlement using Monerium 

After customers redeem gift cards at several retailers, these amounts have to be summed up and transfered to the retailers' bank account. This is made possible by the help of Monerium's e-money solution. Using Monerium's API, the total amount calculated fir each retailer can be transfered from the Mall's Monerium account to the retailers' bank account automatically at regular predefined intervals.
