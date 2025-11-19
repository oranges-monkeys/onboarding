export function convertDistance(value, from, to) {
  if (from === "km" && to === "mi") return value * 0.621371;
  if (from === "mi" && to === "km") return value / 0.621371;
  throw new Error(`Unsupported distance conversion: ${from} to ${to}`);
}
