import configs from "./configs";
import ReactDOM from "react-dom";
import React from "react";
import * as Sentry from "@sentry/browser";
import "abortcontroller-polyfill/dist/polyfill-patch-fetch";
import App from "./ui/App";
import Api from "./api/Api";
import { initTelemetry } from "./telemetry";

const token = new URLSearchParams(location.search).get("token");
window.token = token;
if (token) {
  localStorage.clear();
  localStorage.setItem("___hubs_store", JSON.stringify({ credentials: { email: "default", token } }));
}

const isCreatingProject = location.href.split("?")[0].includes("new");
window.isCreatingProject = !!isCreatingProject;

const eventCallback = new URLSearchParams(location.search)?.get("event-callback");
if (eventCallback) {
  window.eventCallback = decodeURI(eventCallback);
}

if (configs.SENTRY_DSN) {
  Sentry.init({
    dsn: configs.SENTRY_DSN,
    release: process.env.BUILD_VERSION,
    integrations(integrations) {
      return integrations.filter(integration => integration.name !== "Breadcrumbs");
    }
  });
}

initTelemetry();

// eslint-disable-next-line no-undef
console.info(`Spoke version: ${process.env.BUILD_VERSION}`);

const api = new Api();

ReactDOM.render(<App api={api} />, document.getElementById("app"));