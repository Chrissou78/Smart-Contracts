import React, { useContext } from "react";
import Container from "@mui/material/Container";
import Box from "@mui/material/Box";
import { AppContext } from "../utils";
import logoSmall from "../images/probets-200.png";

export default function Header({}) {
  const { account, connect, disconnect } = useContext(AppContext);

  return (
    <>
    <Box
      position="relative"
      zIndex={1}
      style={{background: "#944a2b", zIndex: "100px", height: {md: "100px", xs: "70px"}}}
      width="100%"
    >
      <Container maxWidth="xl">
        <Box
          display="flex"
          justifyContent="space-between"
          alignItems="center"
          py={1}
        >
          <Box component="img" sx={{width: {md: "80px", xs: "40px" }}} src={logoSmall} alt="" />
          <Box
                sx={{ fontSize: {md: '40px', xs:'24px'} }}
                fontWeight="800"
                display="flex"
                color="#ffffff"
                fontFamily="Inter,sans-serif"
                textAlign="center"
              >Pro Bets
          </Box>
          <Box display="flex" alignItems="center">

            {account ? (
              <>
                <Box
                  width="100px"
                  height="30px"
                  bgcolor="#ffffff"
                  borderRadius="5px"
                  sx={{ cursor: "pointer", fontSize: {md: "18px", xs: "12px" }, width: {md: "150px", xs: "100px" }, height: {md: "42px", xs: "30px" }}}
                  display="flex"
                  justifyContent="center"
                  alignItems="center"
                  color="#944a2b"
                  fontWeight="600"
                  onClick={() => disconnect()}
                  style={{ zIndex: 1 }}
                >
                  {account.slice(0, 4) + "..." + account.slice(-4)}
                </Box>
              </>
            ) : (
              <Box
                zIndex={1}
                sx={{ cursor: "pointer", fontSize: {md: "18px", xs: "12px" }, width: {md: "150px", xs: "100px" }, height: {md: "42px", xs: "30px" }}}
                bgcolor="#ffffff"
                fontWeight="600"
                borderRadius="5px"
                fontSize="18px"
                color="#944a2b"
                display="flex"
                justifyContent="center"
                alignItems="center"
                onClick={() => connect()}
              >
                Connect Wallet
              </Box>
            )}
          </Box>
        </Box>
      </Container>
    </Box>
    </>
  );
}
