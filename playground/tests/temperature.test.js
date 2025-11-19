import { test } from "node:test";
import { strictEqual } from "node:assert";
import { convertTemperature } from "../src/lib/temperature.js";

test("converts Celsius to Fahrenheit", () => {
  strictEqual(convertTemperature(0, "C", "F"), 32);
  strictEqual(convertTemperature(100, "C", "F"), 212);
});

test("converts Fahrenheit to Celsius", () => {
  strictEqual(convertTemperature(32, "F", "C"), 0);
  strictEqual(convertTemperature(212, "F", "C"), 100);
});
