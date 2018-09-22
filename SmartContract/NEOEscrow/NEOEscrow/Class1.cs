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
            public const string keyNumGames = "numGames";


            public const string keyAcc = "a";
            public const string keyProd = "p";
            public const string keyEntry = "e";
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
            public BigInteger buyerId;
            public BigInteger sellerId;
            public BigInteger prodId;
            public BigInteger number;
            public bool finished;
        }


        [Serializable]
        public class Game{
            public BigInteger heightStage1;
            public BigInteger heightStage2;
            public BigInteger numEntries;
            public bool isFinalized;
            public byte[] winnerPick;
        }

        /**
            Deploy or reset the game world. Only the owner account can do it. 
        */
        private static bool Deploy(){
            BigInteger i = 0;
            NuIO.SetStorageWithKey(Global.keyNumGames, Op.BigInt2Bytes(i));
            return true;
        }


        public static BigInteger NumAccounts(){
            return NuIO.GetStorageWithKey(Global.keyNumAccounts).AsBigInteger();
        }

        public static BigInteger NumProducts(){
            return NuIO.GetStorageWithKey(Global.keyNumProducts).AsBigInteger();
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


        //
        public static BigInteger PostEscrow(BigInteger buyerId, BigInteger sellerId, BigInteger prodID, BigInteger num){
            byte[] buyerData = NuIO.GetStorageWithKeyPath(Global.keyAcc, buyerId.AsByteArray().AsString());
            byte[] sellerData = NuIO.GetStorageWithKeyPath(Global.keyAcc, sellerId.AsByteArray().AsString());
            byte[] prodData = NuIO.GetStorageWithKeyPath(Global.keyAcc, prodID.AsByteArray().AsString());


            if(buyerData.Length == 0 || sellerData.Length == 0 ||  prodData.Length == 0){
                return 0;
            }
            else{
                
                User user = (User)buyerData.Deserialize();

            }
        }

        /**
            Start a new game. Only the owner account can do it. 
        */
        private static bool StartGame(){
            BigInteger num = Op.Bytes2BigInt(NuIO.GetStorageWithKey(Global.keyNumGames));

            Game game = new Game();
            BigInteger currentHeight = Blockchain.GetHeight();
            game.heightStage1 = currentHeight + Global.Stage1Height;
            game.heightStage2 = currentHeight + Global.Stage2Height;
            game.numEntries = 0;
            game.isFinalized = false;
            byte[] data = game.Serialize();
            BigInteger gameid = NumGames();
            NuIO.SetStorageWithKeyPath(data, Global.keyGame, Op.BigInt2String(gameid));
            NuIO.SetStorageWithKey(Global.keyNumGames, Op.BigInt2Bytes(gameid + 1));
            string a = data.AsString();
            return true;

        }


        /**
            In the 1st stage of each game, players are only allowed to submit the 
            hidden number's hash, rather than it hidden value itself.
        */
        public static byte[] PutEntry(BigInteger gameId, byte[] address, byte[] pick, byte[] hiddenHash)
        {

            Game game = GetGame(gameId);
            if(game == null){
                return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.BadRequest);
            }
            else
            {
                
                if (Blockchain.GetHeight() >= game.heightStage1)
                {
                    return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.Forbidden);;
                }
                else
                {
                    Entry entry = new Entry();
                    entry.gameId = gameId;
                    entry.address = address;
                    entry.pick = pick;
                    entry.hiddenHash = hiddenHash;
                    byte[] data = entry.Serialize();
                    BigInteger id = NumEntries(gameId);
                    NuIO.SetStorageWithKeyPath(data, Global.keyGame, Op.BigInt2String(gameId),Global.keyEntry, Op.BigInt2String(id));

                    game.numEntries += 1;
                    NuIO.SetStorageWithKeyPath(game.Serialize(), Global.keyGame, Op.BigInt2String(gameId));

                    return NuTP.RespDataSucWithBody(data);
                }

            }

        }


        /**
            In the 2nd stage of each game, players submit the hidden number(prove), nobody can fake it 
            since it must match the hash every player submitted in during first round.
            If a user failed to submit the prove, s/he will be elimiated from this game.
        */
        public static byte[] PutProve(BigInteger gameId ,BigInteger entryId, byte[] hidden)
        {
            Entry entry = GetEntry(gameId,entryId);

            Game game = GetGame(gameId);
            BigInteger height = Blockchain.GetHeight();
            if (height < game.heightStage1 || height > game.heightStage2)
            {
                return NuTP.RespDataWithCode(NuTP.SysDom,NuTP.Code.Forbidden);
            }
            else
            {   
                if (Hash256(hidden) == entry.hiddenHash)
                {
                    entry.hidden = hidden;
                    return NuTP.RespDataSuccess();
                }
                else
                {
                    return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.BadRequest);
                }
            }

        }

        /**
            After 2nd stage finished, anybody can query the winnerPick.
        */
        public static byte[] CalcResult(BigInteger gameId){
            Game game = GetGame(gameId);
            if(game == null){
                return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.BadRequest);
            }
            else{
                if (game.winnerPick[0]==1)
                {
                    return NuTP.RespDataSucWithBody(game.winnerPick);
                }
                else
                {
                    BigInteger height = Blockchain.GetHeight();
                    if (height < game.heightStage2)
                    {
                        return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.Forbidden);
                    }
                    else
                    {
                        BigInteger salt = 0;
                        for (int i = 0; i < game.numEntries; i++)
                        {
                            Entry entry = GetEntry(gameId, i);
                            if (entry.hidden.Length != 0)
                            {
                                salt += Op.Bytes2BigInt(entry.hidden);
                            }
                        }
                        byte[] winnerPick = Op.SubBytes(Hash256(salt.ToByteArray()), 0, 1);
                        game.winnerPick = winnerPick;
                        return NuTP.RespDataSucWithBody(winnerPick);
                    }
                }
            }
        }

        public static byte[] IsWinner(BigInteger gameId, BigInteger entryId){
            Game game = GetGame(gameId);
            if (game == null){
                return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.BadRequest);
            }
            else{
                BigInteger height = Blockchain.GetHeight();
                if (height < game.heightStage2){
                    return NuTP.RespDataWithCode(NuTP.SysDom, NuTP.Code.Forbidden); 
                }
                else{
                    
                    Entry entry = GetEntry(gameId, entryId);
                    bool ret = entry.pick == game.winnerPick;
                    return NuTP.RespDataSucWithBody(Op.Bool2Bytes(ret));
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
                if (Runtime.CheckWitness(Owner))
                {
                    return Deploy();
                }

            }

            if(op == "startGame")
            {
                if (Runtime.CheckWitness(Owner))
                {
                    return StartGame();
                }
            }

            if(op == "putEntry")
            {
                BigInteger gameID = ((byte[])args[0]).AsBigInteger();
                byte[] address = (byte[])args[1];
                byte[] pick = (byte[])args[2];
                byte[] hiddenHash = (byte[])args[3];
                return PutEntry(gameID, address, pick, hiddenHash);
            }

            if(op == "putProve")
            {
                BigInteger gameId = (BigInteger)args[0];
                BigInteger entryId = (BigInteger)args[1];
                byte[] hidden = (byte[])args[2];
                return PutProve(gameId, entryId, hidden);
            }


            if (op == "checkResult")
            {
                BigInteger gameId = ((byte[])args[0]).AsBigInteger();
                return CalcResult(gameId);
            }
            else return false;
        }
    
        public static BigInteger NumGames()
        {
            return Op.Bytes2BigInt(NuIO.GetStorageWithKey(Global.keyNumGames));
        }

        public static Game GetGame(BigInteger gameId)
        {
            return (Game)NuIO.GetStorageWithKeyPath(Global.keyGame, Op.BigInt2String(gameId)).Deserialize();
        }

        public static BigInteger NumEntries(BigInteger gameId)
        {
            Game game = GetGame(gameId);
            return game.numEntries;

        }

        public static Entry GetEntry(BigInteger gameId, BigInteger entryId)
        {

            return (Entry)NuIO.GetStorageWithKeyPath(Global.keyGame, Op.BigInt2String(gameId), Global.keyEntry, Op.BigInt2String(entryId)).Deserialize();
        }
    }
}
