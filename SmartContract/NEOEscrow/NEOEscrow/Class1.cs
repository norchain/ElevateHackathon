using System;
using System.Text;

#if NEOSC
using Neunity.Adapters.NEO;
using Neo.SmartContract.Framework;
using Neo.SmartContract.Framework.Services.Neo;
using Neo.SmartContract.Framework.Services.System;
using Helper = Neo.SmartContract.Framework.Helper;
#else
using Neunity.Adapters.Unity;
#endif

using System.Numerics;
using Neunity.Tools;
using System.Net.Sockets;

namespace Escrow
{
    public class Escrow : SmartContract
    {

        public const string sp = "/";
        public const byte unknown = 0;
        public const byte known = 1;
        public static readonly byte[] escrowAddr = "AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y".ToScriptHash();

        public static class Global{
            public const string keyNumEntries = "numEntries";
            public const string keyNumAccounts = "nAcc";
            public const string keyNumProducts = "nProd";
            public const string keyNumPurchases = "nPurch";


            public const string keyAcc = "a";
            public const string keyProd = "p";
            public const string keyPurchase = "e";
            public const string keyGame = "g";

            public const long MaxEntries = 999999;
            public const long PerEntryGas = 1;
            public const long Stage1Height = 3000;
            public const long Stage2Height = 6000;
        }


        [Serializable]
        public class User{
            public BigInteger index;
            public byte[] address;
            public BigInteger balance;
            public string name;
        }

        [Serializable]
        public class Product{
            public BigInteger index;
            public string SKU;
            public BigInteger idSeller;
            public string name;
            public BigInteger price;
            public string description;
        }


        [Serializable]
        public class Purchase{
            public BigInteger index;
            public BigInteger buyerId;
            public BigInteger sellerId;
            public BigInteger prodId;
            public BigInteger number;
            public BigInteger amount;
            public bool finished;
            public BigInteger stars;
            public string comment;
        }




        public static BigInteger NumAccounts(){
            return NuIO.GetStorageWithKey(Global.keyNumAccounts).AsBigInteger();
        }

        public static BigInteger NumProducts(){
            return NuIO.GetStorageWithKey(Global.keyNumProducts).AsBigInteger();
        }

        public static BigInteger NumPurchase()
        {
            return NuIO.GetStorageWithKey(Global.keyNumProducts).AsBigInteger();
        }



        public static bool Deploy(){
            return true;
        }
        //Create account information
        public static bool PostAccount(byte[] addr,string name, BigInteger balance){
            BigInteger nowNum = NuIO.GetStorageWithKey(Global.keyNumAccounts).AsBigInteger() + 1;
            User user = new User()
            {
                index = nowNum,
                name = name,
                balance = balance,
                address = addr
            };

            NuIO.SetStorageWithKeyPath(user.Serialize(), Global.keyAcc, NumAccounts().AsByteArray().AsString());

            NuIO.SetStorageWithKey(Global.keyNumAccounts,nowNum.AsByteArray());
            return true;
        }

        //Create prod information
        public static bool PostProduct(BigInteger prodId, string desc, BigInteger price, BigInteger sellerID)
        {
            BigInteger nowNum = NuIO.GetStorageWithKey(Global.keyNumProducts).AsBigInteger() + 1;
            Product listing = new Product()
            {
                index = nowNum,
                idSeller = sellerID,
                description = desc,
                price = price

            };

            NuIO.SetStorageWithKeyPath(listing.Serialize(), Global.keyProd, NumProducts().AsByteArray().AsString());

            NuIO.SetStorageWithKey(Global.keyNumProducts, nowNum.AsByteArray());
            return true;
        }

        private static User GetEscrow(){
            return GetUserById(0);
        }

        private static User GetUserById(BigInteger id){
            byte[] userData = NuIO.GetStorageWithKeyPath(Global.keyAcc, id.AsByteArray().AsString());
            User user = (User)userData.Deserialize();
            return user;
        }

        //
        public static BigInteger PostPurchase(BigInteger buyerId, BigInteger sellerId, BigInteger prodID, BigInteger num){
            byte[] buyerData = NuIO.GetStorageWithKeyPath(Global.keyAcc, buyerId.AsByteArray().AsString());
            byte[] sellerData = NuIO.GetStorageWithKeyPath(Global.keyAcc, sellerId.AsByteArray().AsString());
            byte[] prodData = NuIO.GetStorageWithKeyPath(Global.keyProd, prodID.AsByteArray().AsString());



            if(buyerData.Length == 0 || sellerData.Length == 0 ||  prodData.Length == 0){
                return 0;
            }
            else{
                BigInteger nowNum = NuIO.GetStorageWithKey(Global.keyNumPurchases).AsBigInteger() + 1;

                Product product = (Product)prodData.Deserialize();
                User buyer = (User)buyerData.Deserialize();
                BigInteger cost = product.price * num;
                if(cost > buyer.balance){
                    return 0;
                }
                else{
                    User escrow = GetEscrow();
                    escrow.balance += cost;
                    buyer.balance -= cost;

                    Purchase purchase = new Purchase()
                    {
                        index = nowNum,
                        buyerId = buyerId,
                        sellerId = sellerId,
                        prodId = prodID,
                        number = num,
                        finished = false,
                        amount = cost
                    };
                    byte[] purData = purchase.Serialize();

                    NuIO.SetStorageWithKeyPath(purData.Serialize(), Global.keyAcc, NumPurchase().AsByteArray().AsString());

                    NuIO.SetStorageWithKeyPath(escrow.Serialize(), Global.keyAcc, "0");

                    NuIO.SetStorageWithKey(Global.keyNumPurchases, nowNum.AsByteArray());

                    return nowNum; 
                }
            }
        }


        /**
            Comfirmation for the completion of the purchase
        */
        public static BigInteger PostPurchaseDone(BigInteger buyerID,BigInteger purchaseId, BigInteger stars, String comment){
            byte[] purData = NuIO.GetStorageWithKeyPath(Global.keyPurchase, purchaseId.AsByteArray().AsString());
            byte[] buyerData = NuIO.GetStorageWithKeyPath(Global.keyAcc, buyerID.AsByteArray().AsString());


            if (purData.Length == 0 || buyerData.Length == 0 ){
                return 0;
            }
            else{
                Purchase purchase = (Purchase)purData.Deserialize();
                if(purchase.finished){
                    return 0;
                }
                else{
                    User escrow = GetEscrow();
                    User seller = GetUserById(purchase.sellerId);

                        
                    escrow.balance -= purchase.amount;
                    seller.balance += purchase.amount;

                   
                    purchase.comment = comment;
                    purchase.stars = stars;
                    purchase.finished = true;



                    NuIO.SetStorageWithKeyPath(escrow.Serialize(), Global.keyAcc, "0");
                    NuIO.SetStorageWithKeyPath(seller.Serialize(), Global.keyAcc, purchase.sellerId.AsByteArray().AsString());
                    NuIO.SetStorageWithKeyPath(purchase.Serialize(), Global.keyPurchase, purchaseId.AsByteArray().AsString());
                    return purchaseId;
                }
            }
        }




        public static object Main(string op, params object[] args)
        {
            if (Runtime.Trigger == TriggerType.Verification)
            {
                
            }

            if (op == "deploy")
            {
                if (Runtime.CheckWitness(escrowAddr))
                {
                    return Deploy();
                }
                else{
                    return false;
                }
            }


            if(op == "postAccount")
            {
                byte[] address = (byte[])args[0];
                string name = (string)args[1];
                BigInteger balance = (BigInteger)args[2];

                return PostAccount(address, name, balance);
            }

            if(op == "postProduct")
            {
                BigInteger prodId = (BigInteger)args[0];
                string desc = (string)args[1];
                BigInteger price = (BigInteger)args[2];
                BigInteger sellerId = (BigInteger)args[3];
                return PostProduct(prodId, desc, price,sellerId);
            }


            if (op == "postPurchase")
            {
                BigInteger buyerId = (BigInteger)args[0];
                BigInteger sellerId = (BigInteger)args[1];
                BigInteger prodID = (BigInteger)args[2];
                BigInteger num = (BigInteger)args[3];
                return PostPurchase(buyerId, sellerId, prodID, num);

            }

            if (op == "postPurchaseDone")
            {
                BigInteger buyerId = (BigInteger)args[0];
                BigInteger purchaseID = (BigInteger)args[1];
                BigInteger stars = (BigInteger)args[2];
                string comment = (string)args[3];
                return PostPurchaseDone(buyerId, purchaseID, stars, comment);

            }


            else return false;
        }
    
    }
}
