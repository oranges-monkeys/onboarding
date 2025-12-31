import * as temperature from "./lib/temperature.js";
import * as distance from "./lib/distance.js";
import * as weight from "./lib/weight.js";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const defaults = JSON.parse(
  readFileSync(join(__dirname, "../config/defaults.json"), "utf-8")
);

export function convert(type, value, from, to) {
  // Validate input value
  if (typeof value === "string") {
    // Try to convert string to number
    const numValue = Number(value);
    if (isNaN(numValue)) {
      throw new Error("Invalid number: " + value);
    }
    value = numValue;
  }
  
  // Check for NaN
  if (isNaN(value)) {
    throw new Error("Invalid number: NaN");
  }
  
  // Check for non-numeric types
  if (typeof value !== "number") {
    throw new Error("Invalid number: " + value);
  }
  
  // Validate conversion type
  if (type !== "temperature" && type !== "distance" && type !== "weight") {
    throw new Error("Unknown conversion type: " + type);
  }
  
  let result;
  switch (type) {
    case "temperature":
      result = temperature.convertTemperature(
        value,
        from || defaults.temperature.defaultFrom,
        to || defaults.temperature.defaultTo
      );
      break;
    case "distance":
      result = distance.convertDistance(value, from, to);
      break;
    case "weight":
      result = weight.convertWeight(value, from, to);
      break;
  }
  
  // Apply precision rounding
  const precision = defaults.precision || 2;
  const factor = Math.pow(10, precision);
  return Math.round(result * factor) / factor;
}
