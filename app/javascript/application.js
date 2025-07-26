// Entry point for the build script in your package.json
// import "@hotwired/turbo-rails"
import "./controllers"
import Rails from "@rails/ujs";
Rails.start(); // ← これが大事！

import $ from "jquery";
window.$ = $;

import "./map";
import "./channels"
