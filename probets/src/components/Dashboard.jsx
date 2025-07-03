import { Box, Container, Grid, useMediaQuery } from "@mui/material";
import React, { useContext, useEffect, useState } from "react";
import { useTokenContract } from "../ConnectivityAss/hooks";
import ProBet from "../images/probets-32.png";
import Image from "../images/sport.jpg";
import Twitter from "../images/twitter.png";
import Telegram from "../images/telegram.png";
import Website from "../images/website.png";
import detectEthereumProvider from '@metamask/detect-provider'
import { AppContext } from "../utils";
import { formatUnits } from "@ethersproject/units";
export default function Dashboard() {
  const matches = useMediaQuery("(max-width:760px)");
  const { account, signer } = useContext(AppContext);
  const tokenContract = useTokenContract(signer);
  const [probetBalance, setprobetBalance] = useState(0);
  const [deadBalance, setDeadBalance] = useState(0);
  const [pendingDistribution, setpendingDistribution] = useState(0);
  const [totalDistributed, settotalDistributed] = useState(0);
  const [totalDividends, settotalDividends] = useState(0);
  const [totalSupply, setTotalSupply] = useState(0);
  const [totalDividendsDistributed, settotalDividendsDistributed] = useState(0);
  const [claiming, setClaiming] = useState(false);
  const [probetPrice, setprobetPrice] = useState(0);
  const [probet$Price, setprobet$Price] = useState(0);
  // Update 16/10/2022
  const [date, setdate] = useState("05/11/2022");
  const [InitialWager, setInitialWager] = useState(300);
  const [ActualWager, setActualWager] = useState(2692);
  const [WeeklyEarning, setWeeklyEarning] = useState(684);
  const [TotalEarning, setTotalEarning] = useState(6556);
  const [ManualBuybacks, setManualBuybacks] = useState(369420);
  const [TeamWon, setTeamWon] = useState(105);
  const [TeamLost, setTeamLost] = useState(61);
  const [CommWon, setCommWon] = useState(4);
  const [CommLost, setCommLost] = useState(8);
  
  const [ReinjectedGains, setReinjectedGains] = useState(0);
  
  const initData = async () => {
    try {
      const response2 = await fetch('https://api.pancakeswap.info/api/v2/tokens/0x577a5ccf5967a0721a8B0F97Ec58acE03A36C4B6');
      const data2 = await response2.json();
      setprobetPrice(data2.data.price_BNB.toString());
      setprobet$Price(data2.data.price.toString());
      const Supply = await tokenContract.GetSupplyInfo();
      setTotalSupply(parseFloat(formatUnits(Supply[1],9)));
      setDeadBalance(parseFloat(formatUnits(Supply[2],9)));
      const dividends = await tokenContract.GetDividendInfo();
      settotalDividends(dividends[0].toString());
      settotalDividendsDistributed(formatUnits(dividends[1].toString(),18));
      setReinjectedGains(formatUnits(dividends[2].toString(),18));
    } catch (error) {}
    if (account) {
      try {
        const dividendInfo = await tokenContract.getAccountToken1DividendsInfo(account);
        setpendingDistribution(formatUnits(dividendInfo[3].toString()));
        settotalDistributed(formatUnits(dividendInfo[4].toString()));
        const result = await tokenContract.balanceOf(account);
        setprobetBalance(parseFloat(formatUnits(result, 9)));
      } catch (error) {}
    }
  };

  const [count, setCount] = useState(0);
  useEffect(() => {setTimeout(() => {setCount((count) => count + 1);}, 10000);});
  useEffect(() => {initData();});

  // Function run to claim rewards
  async function claimDividends() {
    try {
      setClaiming(true);
      await tokenContract.claim();
      setClaiming(false);
    } catch (error) {
      console.log(error);
      setClaiming(false);
    }
  }

  return (
    <div style={{backgroundImage: `url(${Image})`,
      backgroundPosition: 'center',
      backgroundSize: 'cover',
      backgroundRepeat: 'no-repeat'}}>
    <Box pb={10} sx={{ height: {md: '100%', xs:'100%'} }}>
      <Container maxWidth="xl">
        <Grid container spacing={matches ? 2 : 2}>
          <Grid item xs={12} md={12}>
            <Box
              height="100%"
              p={1.5}
              mt={2}
              borderRadius="10px"
              display="flex"
              flexDirection="column"
              alignItems="center"
              justifyContent="space-between"
              sx={{
                background: "#944a2b",
              }}
            >
              <Box
                fontWeight="400"
                sx={{ fontSize: {xl: '20px', md: '16px', xs:'12px'}}}
                color="#ffffff"
                fontFamily="Inter,sans-serif"
                textAlign="left"
              >
                PRO BETS was initiated to provide ordinary traders with a token 
                designed to be a source of real and lasting passive income. 
                Income that is not just another ordinary crypto based “Fugazi” but actual money, 
                profits coming in into the project itself. We want to be known as a very successful 
                token in the Binance Smart Chain through our innovative use case and amazing community.
              </Box>
              
              <Box
                style={{cursor: "pointer",}}
                bgcolor="#944a2b"
              >
                <a style={{textDecoration:'none', marginRight: '1rem'}} href="https://t.me/probetstoken" target="_blank" rel="noreferrer"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src={Telegram} alt="" /></a>
                <a style={{textDecoration:'none', marginRight: '1rem'}} href="https://twitter.com/Probets12" target="_blank" rel="noreferrer"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src={Twitter} alt="" /></a>
                <a style={{textDecoration:'none', marginRight: '1rem'}} href="https://probetstoken.com/" target="_blank" rel="noreferrer"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src={Website} alt="" /></a>
              </Box>
              <Box
                fontWeight="800"
                sx={{fontSize: {md:"15px", xs:"10px"}}}
                display="flex"
                color="#ffffff"
                fontFamily="Inter,sans-serif"
                textAlign="center"
                style={{cursor: "pointer",}}
                onClick={async () => {
                  const provider = await detectEthereumProvider()
                  provider.sendAsync({
                    method: 'metamask_watchAsset',
                    params: {"type": "ERC20", "options": {"address": '0x577a5ccf5967a0721a8B0F97Ec58acE03A36C4B6', "name": 'Pro Bets', "symbol": 'PBT', "decimals": 9, "image": ProBet},}, 
                    id: Math.round(Math.random() * 100000),}, (err, added) => {console.log('provider returned', err, added)})}}
                  > Add Pro Bets to your Metamask {''}
                  <img style={{textDecoration:'none', marginLeft:'1rem'}} width="20px" src={ProBet} alt="" />
              </Box>
            </Box>
          </Grid>
        </Grid>
        <Grid container >
          <Grid container xs={12} mt={8} px={1} py={1}
            sx={{background: "#944a2b",}}
            display="flex"
            borderRadius="10px"
            justifyContent="space-between" 
            >           
            <Grid container xs={12} px={1} py={1}
              justifyContent="space-evenly"
              alignItems="center"
              fontWeight="800"
              color="#ffffff"
              border="2px solid"
              borderRadius="10px"
              fontFamily="Inter,sans-serif" 
              textAlign="center">            
              <Grid container xs={12} md={5.8}
                  bgcolor="#000000"
                  mt={2} px={1} py={0.5}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={7} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Your Wallet Infos</Grid>
                  { account ?
                  <>
                  <Grid item xs={5} mt={1} px={1}
                    textAlign="left"
                    color="#ffffff">
                    <Box
                      sx={{ cursor: "pointer", fontSize: {md: "22px", xs: "14px" }, width: {md: "150px", xs: "100px" }, height: {md: "42px", xs: "30px" }}}
                      bgcolor="#944a2b"
                      disabled={true}
                      mt={0} px={1} py={0.5}
                      fontWeight="700"
                      borderRadius="5px"
                      color="#ffffff"
                      fontFamily="Inter,sans-serif"
                      textAlign="center"
                      onClick={() => { if (claiming === true) {console.log("Currently claiming, Can't claim while function is running");
                      } else {claimDividends();}}}
                      >Claim
                    </Box>
                  </Grid>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{probetBalance.toLocaleString('en-US', {maximumFractionDigits:2})} PBT </Grid>
                  <Grid item xs={12} mt={-2}
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#2a9159">$ {(probet$Price * probetBalance).toLocaleString('en-US', {maximumFractionDigits:2})}</Grid>
                  <Grid item md={3} xs={8} px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Pending Amount to Distribute : </Grid>
                  <Grid item md={3} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(pendingDistribution).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD </Grid>
                  <Grid item md={2.5} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Total Distributed : </Grid>
                  <Grid item md={3.5} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(totalDistributed).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    color="#ffffff">
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" />
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" />
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" />
                  </Grid><br/><br/>
              </>
                : 
                <Grid item xs={12}
                  fontWeight="700"
                  sx={{ fontSize: {md: '24px', xs:'16px'} }}
                  color="#ffffff"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                >
                  Connect your wallet to track your Pro Bets dividends!
                </Grid>}
              </Grid>
              <Grid container xs={12} md={5.8} 
                  bgcolor="#000000"
                  mt={2} px={1} py={1}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item md={5} xs={12}  mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Circulating Supply </Grid>
                  <Grid item md={7} xs={12}  mt={1} px={1}
                    sx={{ textAlign: {md: "right", xs:"left"}, fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Initial Supply : {parseInt(parseFloat(totalSupply)+parseFloat(deadBalance)).toLocaleString('en-US', {maximumFractionDigits:0})} PBT </Grid><br/><br/>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{totalSupply.toLocaleString('en-US', {maximumFractionDigits:0})} PBT </Grid><br/><br/>
                  <Grid item md={1.8} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">M Cap : <br/> Holders : </Grid>
                  <Grid item md={2.2} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">$ {(probet$Price * totalSupply).toLocaleString('en-US', {maximumFractionDigits:2})}  <br/> {totalDividends}</Grid>
                  <Grid item md={3} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">ProBets Price : </Grid>
                  <Grid item md={5} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{(probetPrice*1/1).toLocaleString('en-US', {maximumFractionDigits:8})} BNB <br/> $ {(probet$Price*1/1).toLocaleString('en-US', {maximumFractionDigits:8})}</Grid>
              </Grid>
              <Grid container xs={12} md={5.8}                     
                  bgcolor="#000000"
                  mt={2} px={1} py={1}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={8} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Bets Track Record</Grid>
                  <Grid item xs={4} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">{parseFloat(parseInt(TeamWon)+parseInt(CommWon)+parseInt(TeamLost)+parseInt(CommLost)).toLocaleString('en-US', {maximumFractionDigits:0})} Bets </Grid>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{parseInt(100*(parseInt(TeamWon)+parseInt(CommWon))/(parseInt(TeamWon)+parseInt(CommWon)+parseInt(TeamLost)+parseInt(CommLost))).toLocaleString('en-US', {maximumFractionDigits:2})} % </Grid><br/>
                  <Grid item xs={4} px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Team % :</Grid>
                  <Grid item xs={2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{100*parseFloat(parseInt(TeamWon)/(parseInt(TeamWon)+parseInt(TeamLost))).toFixed(2)} % </Grid>
                    <Grid item xs={4} px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Community % :</Grid>
                  <Grid item xs={2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{100*parseFloat(parseInt(CommWon)/(parseInt(CommWon)+parseInt(CommLost))).toFixed(2)} % </Grid>
                  <Grid item xs={4} px={1} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">Won :</Grid>
                  <Grid item xs={2} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{TeamWon}</Grid>
                    <Grid item xs={4} px={1} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">Won :</Grid>
                  <Grid item xs={2} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{CommWon}</Grid>
                    <Grid item xs={4} px={1} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#b81111">Lost : </Grid>
                  <Grid item xs={2} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#b81111">{TeamLost}</Grid>
                  <Grid item xs={4} px={1} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#b81111">Lost :</Grid>
                  <Grid item xs={2} mt={-2}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#b81111">{CommLost}</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" />
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" /></Grid>
              </Grid>
              <Grid container xs={12} md={5.8}                     
                  bgcolor="#000000"
                  mt={2} px={1} py={1}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={11} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Wager Fund</Grid><br/><br/>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{parseFloat(ActualWager).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD </Grid><br/>
                  <Grid item md={2.6} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Initial Wager : </Grid>
                  <Grid item md={3.4} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">$ {parseFloat(InitialWager*1/1).toFixed(2)}</Grid>
                    <Grid item md={2.5} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Reinjected <br/>in Wager :</Grid>
                  <Grid item md={3.5} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(ActualWager - InitialWager).toFixed(2)} BUSD <br/> {parseFloat((100*ActualWager/InitialWager)-100).toFixed(2)} %</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/smiley/eyes-glowing-emoji-hd-png-XgtgeW.png" alt=""/></Grid>
              </Grid>
              <Grid container xs={12} md={5.8}                     
                  bgcolor="#000000"
                  mt={2} px={1} py={0.5}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={12} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Total Bet Earnings</Grid><br/><br/>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{parseFloat(TotalEarning).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD </Grid><br/>
                  <Grid item md={3.2} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">% (Initial Wager) : </Grid>
                  <Grid item md={2.8} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(100*TotalEarning/InitialWager).toFixed(2)} %</Grid>
                    <Grid item md={3.2} xs={8}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">% Redistributed <br/>(Initial Wager) : </Grid>
                  <Grid item md={2.8} xs={4} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat((100*ReinjectedGains/ActualWager)).toFixed(2)} %</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/smiley/eyes-glowing-emoji-hd-png-XgtgeW.png" alt=""/></Grid>
              </Grid>  
              <Grid container xs={12} md={5.8} 
                  bgcolor="#000000"
                  mt={2} px={1} py={0.5}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={12} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">This Week Earnings</Grid><br/><br/>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{parseFloat(WeeklyEarning*1/1).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD </Grid><br/><br/>
                  <Grid item md={3.5} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">% (Initial Wager) : </Grid>
                  <Grid item md={2.5} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(100*WeeklyEarning/InitialWager).toFixed(2)} %</Grid>
                  <Grid item md={4} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">% (Actual Wager) : </Grid>
                  <Grid item md={2} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(100*WeeklyEarning/ActualWager).toFixed(2)} %</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" /></Grid>
              </Grid>
              <Grid container xs={12} md={5.8}  
                bgcolor="#000000"
                mt={2} px={1} py={0.5}
                width="150px"
                height="240px"
                fontWeight="700"
                borderRadius="21px"
                color="#2a9159"
                fontFamily="Inter,sans-serif"
                textAlign="center">            
                  <Grid item xs={12} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Rewards / Gains Total</Grid><br/><br/>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{parseFloat(totalDividendsDistributed).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD</Grid><br/>
                  <Grid item md={2.5} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Tax Reward : </Grid>
                  <Grid item md={3.5} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(totalDividendsDistributed - ReinjectedGains).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD <br/>{parseFloat((100*(totalDividendsDistributed - ReinjectedGains)/totalDividendsDistributed)).toFixed(2)} %</Grid>
                    <Grid item md={2.5} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Reinjected <br/>Gains : </Grid>
                  <Grid item md={3.5} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(ReinjectedGains).toLocaleString('en-US', {maximumFractionDigits:2})} BUSD <br/>{parseFloat((100*ReinjectedGains/totalDividendsDistributed)).toFixed(2)} %</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff"><Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/smiley/eyes-glowing-emoji-hd-png-XgtgeW.png" alt=""/></Grid>
              </Grid>                
              <Grid container xs={12} md={5.8}
                  bgcolor="#000000"
                  mt={2} px={1} py={0.5}
                  width="150px"
                  height="240px"
                  fontWeight="700"
                  borderRadius="21px"
                  color="#2a9159"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                  > 
                  <Grid item xs={8} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">Burnt Tokens Infos</Grid>
                  <Grid item xs={4} mt={1} px={1}
                    textAlign="left"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#2a9159">{parseFloat(100*deadBalance/(totalSupply+deadBalance)).toFixed(2)} %</Grid>
                  <Grid item xs={12}
                    sx={{ fontSize: {md: '40px', xs:'24px'} }}
                    color="#2a9159">{deadBalance.toLocaleString('en-US', {maximumFractionDigits:0})} PBT</Grid>
                  <Grid item xs={12} mt={-2}
                    sx={{ fontSize: {md: '24px', xs:'16px'} }} color="#2a9159">$ {(probet$Price * deadBalance).toLocaleString('en-US', {maximumFractionDigits:2})}</Grid>
                  <Grid item md={3} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Buybacks Burnt : </Grid>
                  <Grid item md={4} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{parseFloat(ManualBuybacks).toLocaleString('en-US', {maximumFractionDigits:0})} PBT <br/>{parseFloat((100*ManualBuybacks/deadBalance)).toFixed(2)} %</Grid>
                  <Grid item md={2.5} xs={6}  px={1}
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#ffffff">Tax Burnt : </Grid>
                  <Grid item md={2.5} xs={6} 
                    sx={{ fontSize: {md: '16px', xs:'10px'} }}
                    textAlign="left"
                    color="#2a9159">{(deadBalance-ManualBuybacks).toLocaleString('en-US', {maximumFractionDigits:0})} PBT <br/>{parseFloat((100*(deadBalance-ManualBuybacks)/deadBalance)).toFixed(2)} %</Grid>
                  <Grid item xs={12} px={1}
                    textAlign="right"
                    sx={{ fontSize: {md: '24px', xs:'16px'} }}
                    color="#ffffff">
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" />
                    <Box component="img" sx={{width: {md: "30px", xs: "20px" }}} src="https://www.transparentpng.com/thumb/star/dQw2pM-star-free-download-transparent.png" alt="" /></Grid>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
        <Grid container xs={12} mt={4} px={1} py={1}
            sx={{background: "#944a2b",}}
            display="flex"
            borderRadius="10px"
            justifyContent="space-between" 
            >           
            <Grid container xs={12} px={1} py={1}
              justifyContent="space-evenly"
              alignItems="center"
              fontWeight="800"
              color="#ffffff"
              border="2px solid"
              borderRadius="10px"
              fontFamily="Inter,sans-serif" 
              textAlign="center">            
              <Grid item xs={12} md={12} mt={0} sx={{ fontSize: {md: '32px', xs:'16px'} }}> Last Update {date}
              </Grid>
              <Grid item xs={12} md={6} mt={0}>
                <Box component="img" sx={{width: {md: "600px", xs: "300px" }, height: {md: "400px", xs: "200px" }}} src="https://docs.google.com/spreadsheets/d/e/2PACX-1vS9myB6nLoyoxU-WcnyytX_jbhAZiwKKjWkvuRIVgOb9On3-ViH0pB2S42UGTGdSvKnCyfChRXf_R6B/pubchart?oid=1051940943&format=image" alt=""/>
              </Grid>
              <Grid item xs={12} md={6} mt={0}>
                <Box component="img" sx={{width: {md: "600px", xs: "300px" }, height: {md: "400px", xs: "200px" }}} src="https://docs.google.com/spreadsheets/d/e/2PACX-1vS9myB6nLoyoxU-WcnyytX_jbhAZiwKKjWkvuRIVgOb9On3-ViH0pB2S42UGTGdSvKnCyfChRXf_R6B/pubchart?oid=736706777&format=image" alt=""/>
              </Grid>
              <Grid item xs={12} md={6} mt={0}>
                <Box component="img" sx={{width: {md: "600px", xs: "300px" }, height: {md: "400px", xs: "200px" }}} src="https://docs.google.com/spreadsheets/d/e/2PACX-1vS9myB6nLoyoxU-WcnyytX_jbhAZiwKKjWkvuRIVgOb9On3-ViH0pB2S42UGTGdSvKnCyfChRXf_R6B/pubchart?oid=1418569351&format=image" alt=""/>
              </Grid>
              <Grid item xs={12} md={6} mt={0}>
                <Box component="img" sx={{width: {md: "600px", xs: "300px" }, height: {md: "400px", xs: "200px" }}} src="https://docs.google.com/spreadsheets/d/e/2PACX-1vS9myB6nLoyoxU-WcnyytX_jbhAZiwKKjWkvuRIVgOb9On3-ViH0pB2S42UGTGdSvKnCyfChRXf_R6B/pubchart?oid=78846310&format=image" alt=""/>
              </Grid>
            </Grid>
          </Grid>
        <Grid container spacing={matches ? 0 : 2}>
          <Grid item xs={12} md={8} mt={2}>
                <Box
                  height="100%"
                  mt={2}
                  display="flex"
                  flexDirection="column"
                  alignItems="center"
                  justifyContent="space-between"
                  fontWeight="1000"
                  color="#ffffff"
                  fontFamily="Inter,sans-serif"
                  textAlign="center"
                ><iframe title="chart" src="https://teams.bogged.finance/embeds/chart?address=0x577a5ccf5967a0721a8B0F97Ec58acE03A36C4B6&chain=bsc&charttype=candles&theme=bg:944a2bFF|bg2:ffffff00|primary:7A7B7BFF|secondary:08080800|text:ffffffFF|text2:944a2bFF|candlesUp:00c303FF|candlesDown:c30000FF|chartLine:944a2bFF&defaultinterval=1h&showchartbutton=false" frameborder="0" height="700" width="100%"/>
                </Box>
          </Grid>
          <Grid item xs={12} md={4} mt={2}>
            <Box
              height="100%"
              mt={2}
              display="flex"
              flexDirection="column"
              alignItems="center"
              justifyContent="space-between"
              fontWeight="1000"
              color="#ffffff"
              fontFamily="Inter,sans-serif"
              textAlign="center"
              ><iframe
                title= "buy"
                width="380"
                height="630"
                frameborder="0"
                allow="clipboard-read *; clipboard-write *; web-share *; accelerometer *; autoplay *; camera *; gyroscope *; payment *; geolocation *"
                src="https://flooz.trade/embed/swap/0x577a5ccf5967a0721a8B0F97Ec58acE03A36C4B6?padding=20&roundedCorners=10&network=bsc&backgroundColor=transparent&refId=Dv3wUP"
                ></iframe>
            </Box>
          </Grid>
        </Grid>
      </Container>
    </Box>
    </div>
  );
}
