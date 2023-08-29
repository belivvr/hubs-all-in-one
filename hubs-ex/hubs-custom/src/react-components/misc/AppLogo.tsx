import React, { useEffect, useState } from "react";

import configs from "../../utils/configs";
import { ReactComponent as HmcLogo } from "../icons/HmcLogo.svg";
import { isHmc } from "../../utils/isHmc";
import { useLogo } from "../styles/theme";

export function AppLogo({ className }: { className?: string }) {
  const [projectLogo, setProjectLogo] = useState('')
  const logo = useLogo();
  // Display HMC logo if account is HMC and no custom logo is configured
  const shouldDisplayHmcLogo = isHmc() && !logo;

  useEffect(() => {
    const optId = new URLSearchParams(window.location.search).get("optId")
    fetch(`${(window as any).serverUrl}/outdoor/option/${optId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      }
    }).then(async (res) => {
      const { faviconUrl, logoUrl, token } = await res.json()
      const link =
      window.document.querySelector("link[rel*='icon']")
      
      if (link) {
        (link as any).href = faviconUrl
      }

      setProjectLogo(logoUrl)
    }).catch((error) => {
      console.log(error)
    })
  }, [])

  return shouldDisplayHmcLogo ? (
    <HmcLogo className="hmc-logo" />
  ) : (
    <img className={className} alt={configs.translation("app-name")} src={projectLogo === '' ? logo : projectLogo} />
  );
}
