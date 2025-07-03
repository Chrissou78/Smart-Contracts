import React, { useEffect, useState } from "react";
import "./App.css";
import Header from "./components/Header";
import { ThemeProvider as ProviderMui } from "@emotion/react";
import { createTheme } from "@mui/material";
import Dashboard from "./components/Dashboard";
import Web3 from "web3";
import NetworkChange from "./networkSwitch";

function App() {
  const [isDarkMode, setisDarkMode] = useState(true);
  const [switchNetwork, setswitchNetwork] = useState(false);

  const LightTheme = createTheme({
    primary: {
      bg: "#ffffff",
      bgButton: "#ffffff",
      text: "#000000",
      basic: "#202532",
      subtext: "#8e98ab",
      heading: "#202532",
      section: "#fff",
      sectionBorder: "1px solid #e7e8ea",
    },
  });

  const DarkTheme = createTheme({
    primary: {
      bg: "#000000",
      bgButton: "#191B1F",
      text: "#ffffff",
      basic: "#fafafa",
      subtext: "#b9babb",
      heading: "#fafafa",
      section: "#1a1e21",
      sectionBorder: "1px solid #262626",
    },
  });

  const web3 = new Web3(
    Web3.givenProvider
      ? Web3.givenProvider
      : "https://bsc-dataseed.binance.org/"
  );
  useEffect(() => {
    let chain = async () => {
      const chainid = await web3.eth.getChainId();
      if (chainid !== 56) {
        if (chainid !== 97) {
            setswitchNetwork(true);
        }
      }
    };
    chain();
  }, []);

  return (
    <>
      <NetworkChange open={switchNetwork} setOpen={setswitchNetwork} />
      <ProviderMui theme={isDarkMode ? DarkTheme : LightTheme}>
        <Header isDarkMode={isDarkMode} setisDarkMode={setisDarkMode} />
        <Dashboard />
      </ProviderMui>
    </>
  );
}

export default App;
