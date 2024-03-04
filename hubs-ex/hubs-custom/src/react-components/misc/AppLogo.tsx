import React from "react";
import configs from "../../utils/configs";

export function AppLogo({ className }: { className?: string }) {
  return (
    <img className={className} alt={configs.translation("app-name")} src="https://cnumetaxr.jnu.ac.kr:4000/files/03c673b0-79c3-4055-9ffa-d97b37bd29be.svg" />
  );
}
